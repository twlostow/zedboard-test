`timescale 1ns/1ps

`include "axi4_lite_master.sv"
`include "ad9263_model.sv"
`include "trigger_generator_wb.vh"
`include "d3s_acq_buffer_wb.vh"

module ChirpGenerator
(
 output real v_o 
);

   parameter g_sample_rate = 105e6;

   const real dt = 1.0 / real'(g_sample_rate);
   const time 	   dt_time = time' ( real'(1000ms) / real'(g_sample_rate) );

   initial v_o = 0;
   

   task automatic chirp( real freq, real a0, real damping );
      
      real a = a0;
      real t = 0;
      $display("Chirp: f %f amplitute %f damping %f", freq, a0, damping);
      
      
      while ( a > (a0 / 10000.0))
	begin
	   a = a0 * $exp ( -t * damping );
	   v_o <= a * $sin(2*3.14159265358*freq*t);
	   t+=dt;
	   
	   #(dt_time);
	end
      
   endtask // chirp
   
   
   

endmodule // ChirpGenerator


module main;
   reg clk = 0;
   reg rst_n = 0;

   IAXI4LiteMaster master ( clk, rst_n ) ;

   always #5ns clk <= ~clk;
   initial begin
      repeat(300) @(posedge clk);

      rst_n = 1;
   end


   wire adc_dco_p, adc_dco_n;
   wire adc_fco_p, adc_fco_n;
   wire [7:0] adc_d_p, adc_d_n;

   real       v_in;

   real       vin_array[4];
   

   ChirpGenerator chirp ( v_in );

   // produce a cn oscillation after 40 us
   initial #40us chirp.chirp( 1e6, 0.8, 5e5);

   assign vin_array[0] = v_in;
        
   ad9263_model 
     ADC(
	 .vin_i(vin_array),

	 .dco_p_o(adc_dco_p),
	 .dco_n_o(adc_dco_n),

	 .fco_p_o(adc_fco_p),
	 .fco_n_o(adc_fco_n),

	 .d_p_o(adc_d_p),
	 .d_n_o(adc_d_n)
	 );
   
   adc_core DUT
     (
      .clk_sys_i(clk),
      .rst_n_i(rst_n),

	 .adc_dco_p_i(adc_dco_p),
	 .adc_dco_n_i(adc_dco_n),

	 .adc_fco_p_i(adc_fco_p),
	 .adc_fco_n_i(adc_fco_n),

	 .adc_d_p_i(adc_d_p),
	 .adc_d_n_i(adc_d_n),

      
      .slave_i(master.vhdl.master_out),
      .slave_o(master.vhdl.master_in)
      );
   

   const uint64_t base_gpio = 'h0000;
   const uint64_t base_trig0 = 'h1000;
   const uint64_t base_buf0 = 'h2000;
   
			      

   task automatic acquire_samples(CBusAccessor acc, uint64_t buffer_addr, int pretrigger, int count, string file_name );
      uint64_t rv, size, trig_pos;
      int i, f;
      
      acc.write(buffer_addr + `ADDR_ACQ_PRETRIGGER, pretrigger);
      acc.write(buffer_addr + `ADDR_ACQ_CSR, `ACQ_CSR_START );

      forever begin
	 acc.read(buffer_addr + `ADDR_ACQ_CSR, rv);
//	 $display("rv %b", rv);
	 
	 if(rv & `ACQ_CSR_READY)
	   break;
      end
      acc.read(buffer_addr + `ADDR_ACQ_TRIG_POS, rv);
      acc.read(buffer_addr + `ADDR_ACQ_SIZE, size);

      trig_pos = rv & 'hffff;
      

      
      $display("ready, %d samples, trigger @ pos = %d", size, trig_pos);

      f = $fopen(file_name,"wb");

      
      for(i = 0; i<count;i++)
	begin
	   int addr = i - pretrigger + trig_pos;
	   
  	   acc.write(buffer_addr + `ADDR_ACQ_ADDR, addr);
	   acc.read(buffer_addr + `ADDR_ACQ_DATA, rv);

	   //isplay("%d %d", i - pretrigger, rv & 'hffff);
	   $fprintf(f,"%d %d\n", i - pretrigger, rv & 'hffff);
	   

	   
	end
      
      
      $fclose(f);
      

   endtask // acquire_samples
   
      
   initial begin
      CBusAccessor acc = master.get_accessor();
      uint64_t rv;

      #10us;
      $display("rst");
      
      acc.write(base_gpio + 'h4, 2); // software reset of the ADC serdes & clocking
      acc.write(base_gpio + 'h0, 2);
      #2us;
      
      acc.write(base_gpio + 'h4, 4); // software reset of the ADC core
      acc.write(base_gpio + 'h0, 4);

      $display("rst done");
      
      #20us;



      
      
      // set up the trigger block for channel 0 (positive edge, mask = channel 0 only)
      acc.write(base_trig0 + `ADDR_TG_THR_LO, 2000);
      acc.write(base_trig0 + `ADDR_TG_THR_HI, 2200);
      acc.write(base_trig0 + `ADDR_TG_CSR, ( 1 <<`TG_CSR_MASK_OFFSET ) | `TG_CSR_ENABLE);
      acc.write(base_trig0 + `ADDR_TG_CSR, ( 1 <<`TG_CSR_MASK_OFFSET ) | `TG_CSR_ENABLE | `TG_CSR_ARM);

      acquire_samples(acc, base_buf0, 300, 1024, "samples.txt");
      

      
   end
   
      
   
   

endmodule // main
