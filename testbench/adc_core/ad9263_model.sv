`timescale 1ps/1ps

module ad9263_model
(
    input real vin_i[4],

    output reg dco_p_o,
    output reg dco_n_o,

    output reg fco_p_o,
    output reg fco_n_o,

    output reg [7:0] d_p_o,
    output reg [7:0] d_n_o
 );
   

    parameter real g_ref_voltage = 1.25;
    parameter real g_sample_rate = 105e6;

   const time 	   bit_time = time' ( real'(1000ms) / real'(g_sample_rate) / 8.0 );

   initial 
     begin
      $display("bit time %d", bit_time);
   end

   task send_bit(int index, int data1, int data2);
      dco_p_o <= 0;
      dco_n_o <= 1;
      d_p_o[index] <= data1 ? 1 : 0;
      d_n_o[index] <= data1 ? 0 : 1;
      d_p_o[index+1] <= data2 ? 1 : 0;
      d_n_o[index+1] <= data2 ? 0 : 1;
      #(bit_time/2);
      dco_p_o <= 1;
      dco_n_o <= 0;
      #(bit_time/2);
   endtask // send_bit
   
   genvar ch;

   
   
   generate
      for(ch=0; ch < 4; ch++)
	   always begin
	      automatic int d = int' ( 8192.0 * (vin_i[ch] / g_ref_voltage) );
	      
	      fco_p_o <= 1;
	      fco_n_o <= 0;
	      send_bit ( 2*ch, d&(1<<12), d&(1<<13) );
	      send_bit ( 2*ch, d&(1<<10), d&(1<<11) );
	      send_bit ( 2*ch, d&(1<<8), d&(1<<9) );
	      send_bit ( 2*ch, d&(1<<6), d&(1<<7) );

	      fco_p_o <= 0;
	      fco_n_o <= 1;

	      send_bit ( 2*ch, d&(1<<4), d&(1<<5) );
	      send_bit ( 2*ch, d&(1<<2), d&(1<<3) );
	      send_bit ( 2*ch, d&(1<<0), d&(1<<1 ) );
	      send_bit ( 2*ch, 0, 0 );
	
	      
	      
	   end // always begin
      endgenerate
   
   
   
   
endmodule
