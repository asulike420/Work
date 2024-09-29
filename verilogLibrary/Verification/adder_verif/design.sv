
module myAdder(
               input wire [31:0] a;
               input wire [31:0] b;
               input wire        clk, reset,
               output reg [32:0] sum

               );

   always @(posedge clk or negedge reset) begin
      if(!reset)
        sum <= {33{1'b0}};//{<<{}}
      else
        sum <= a + b;
   end

endmodule // myAdder
