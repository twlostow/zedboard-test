`include "simdrv_defs.svh"
`include "if_wishbone_types.svh"
`include "if_wishbone_accessor.svh"

`define USE_VHDL_BINDINGS 1

// for VHDL instances
`ifdef USE_VHDL_BINDINGS
import axi4_pkg::*;
`endif

interface IAXI4LiteMaster
  (
   input clk_i,
   input rst_n_i
   );

   parameter g_addr_width 	   = 32;
   parameter g_data_width 	   = 32;

   logic arvalid;
   logic awvalid;
   logic bready;
   logic rready;
   logic wlast ;
   logic wvalid;
   logic [g_addr_width-1:0] araddr;
   logic [g_addr_width-1:0] awaddr;
   logic [g_data_width-1:0] wdata;
   logic [g_data_width/8-1:0] wstrb;
   
   logic 		      arready;
   logic 		      awready;
   logic 		      bvalid;
   logic 		      rlast;
   logic 		      rvalid;
   logic 		      wready;
   logic [1:0] 		      bresp;
   logic [1:0] 		      rresp;
   logic [g_data_width-1:0]   rdata;

   wire clk;
   wire rst_n;
 
   time last_access_t 	  = 0;

   modport master
     (
      output arvalid,
      output awvalid,
      output bready,
      output rready,
      output wlast ,
      output wvalid,
      output araddr,
      output awaddr,
      output wdata,
      output wstrb,
      input  arready,
      input  awready,
      input  bvalid,
      input  rlast,
      input  rvalid,
      input  wready,
      input  bresp,
      input  rresp,
      input  rdata
      );
   

`ifdef USE_VHDL_BINDINGS
   t_axi4_lite_slave_in_32 master_out;
   t_axi4_lite_slave_out_32 master_in;

   modport vhdl
     (
      output master_out,
      input master_in
     );

   assign master_out.arvalid = arvalid;
   assign master_out.awvalid = awvalid;
   assign master_out.bready = bready;
   assign master_out.rready =rready;
   assign master_out.wlast =wlast;
   assign master_out.wvalid=wvalid;
   assign master_out.araddr=araddr;
   assign master_out.awaddr=awaddr;
   assign master_out.wdata=wdata;
   assign master_out.wstrb=wstrb;
   
   assign arready=master_in.arready;
   
      assign   awready=master_in.awready;
      assign   bvalid=master_in.bvalid;
      assign   rlast=master_in.rlast;
      assign   rvalid=master_in.rvalid;
      assign   wready=master_in.wready;
      assign   bresp=master_in.bresp;
      assign   rresp=master_in.rresp;
      assign   rdata=master_in.rdata;
   
`endif
   
   
  
   task automatic write_cycle
     (
      wb_xfer_t xfer,
      ref wb_cycle_result_t result
      );
      
      if($time != last_access_t) 
	    @(posedge clk_i); /* resynchronize, just in case */
      
//      $display("AXI write addr %x data %x", xfer.a, xfer.d);
      

      bready <= 1;
      awvalid <= 1;
      awaddr <= xfer.a;

      @(posedge clk_i);

      while(!awready)
	@(posedge clk_i);

      awvalid <= 0;
      wdata <= xfer.d;
      wstrb <= 'hf; // fixme
      wlast <= 1;
      wvalid <= 1;

      while(!wready)
	@(posedge clk_i);
      wvalid <= 0;
      
      while(!bvalid)
	@(posedge clk_i);
      

//      $display("AXI response: %x", bresp);
      

      result 	     = R_OK;
      last_access_t  = $time;
   endtask // automatic


 task automatic read_cycle
     (
      ref wb_xfer_t xfer,
      ref wb_cycle_result_t result
      );
      
      if($time != last_access_t) 
	    @(posedge clk_i); /* resynchronize, just in case */
      
//      $display("AXI read addr %x", xfer.a );
      

      bready <= 1;
      arvalid <= 1;
      araddr <= xfer.a;
    rready <= 1;
    
      @(posedge clk_i);

      while(!arready)
	@(posedge clk_i);
    
    arvalid <= 0;
    
      while(!rvalid)
	@(posedge clk_i);

    rready <= 0;
      
//    $display("AXI response: %x data %x", rresp, rdata);

    xfer.d = rdata;
    

      result 	     = R_OK;
      last_access_t  = $time;
   endtask // automatic

   
   reg xf_idle 	     = 1;
   
	
   wb_cycle_t request_queue[$];
   wb_cycle_t result_queue[$];

class CAXI4LiteMasterAccessor extends CWishboneAccessor;

   function automatic int poll();
      return 0;
   endfunction
   
   task get(ref wb_cycle_t xfer);
      while(!result_queue.size())
	@(posedge clk_i);
      xfer  = result_queue.pop_front();
   endtask
   
   task clear();
   endtask // clear

   task put(ref wb_cycle_t xfer);
      //       $display("WBMaster[%d]: PutCycle",g_data_width);
      request_queue.push_back(xfer);
   endtask // put

   function int idle();
      return (request_queue.size() == 0) && xf_idle;
   endfunction // idle
endclass // CIWBMasterAccessor


   function CAXI4LiteMasterAccessor get_accessor();
      CAXI4LiteMasterAccessor tmp;
      tmp  = new;
      return tmp;
      endfunction // get_accessoror

   always@(posedge clk_i)
     if(!rst_n_i)
       begin
	  request_queue 	      = {};
	  result_queue 		      = {};
	  arvalid = 0;
	  awvalid = 0;
	  wvalid = 0;
	  bready = 0;
	  rready  = 0;
       end

   
   initial forever
     begin
	@(posedge clk_i);


	if(request_queue.size() > 0)
	  begin
	     wb_cycle_t c;
	     wb_cycle_result_t res;

	     c 	= request_queue.pop_front();

	     if(c.rw)
	       write_cycle(c.data[0], res);
	     else
	       read_cycle(c.data[0], res);
	    
	     c.result  =res;
             
	     result_queue.push_back(c);
	  end
     end
   
   
endinterface
