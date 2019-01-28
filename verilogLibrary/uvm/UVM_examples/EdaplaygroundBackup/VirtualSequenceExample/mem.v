module mem (
	    input wire [3:0] raddr, waddr,
	    input wire 	     wren, rden,
	    input [7:0]      wdata,
	    output [7:0]     rdata,
	    input 	     clk
	    );

   reg [7:0] 		     mem_inst [16], r_data;
   
   assign rdata = r_data;
   
   always @(posedge clk)
     if(!wren)
       r_data <= mem_inst[raddr];
   
   always @(posedge clk)
     if(wren)
       mem_inst[waddr] <= wdata;
   

endmodule // mem
