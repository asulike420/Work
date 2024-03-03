module test();

   reg clk, up_down, reset;
   reg [7:0] data;
   wire [7:0] out;

   up_down_counter DUT (out, up_down, clk, data, reset);
   

   initial
     forever
       // Not correct placement of delay clk =  #5 ~clk;
       #10  clk = ~clk;
   
   initial
     begin
	#0
	  clk = 0;
	reset = 1;
	data = 0;
	up_down = 1;
	
	#20
           
	  reset = 0;
	#500
	  $finish;
     end

   always @(posedge clk)
     $display("counter output out = %b\n",out);
   

   
endmodule
