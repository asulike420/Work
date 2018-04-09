// Code your testbench here
// or browse Examples
module seq_detector(reset, in, clk , detected);

   input logic in, clk, reset;
   
   output logic detected;

  enum 	bit [3:0] {S0=4'b0001, S1=4'b0010, S2=4'b0100, S3=4'b1000} n_state, p_state;

  initial $monitor("%t p_state=%b, in=%b,reset=%b",$time, p_state,in, reset);
   
   
   always @(posedge clk)
     if(!reset) begin
	p_state <= S0;
	detected <= 0;
     end
     else
       begin
	  p_state <= n_state;
	  if (n_state == S3)	detected <= 1;
          else detected <= 0;
       end

   always @(*)
     begin
       case (p_state )//detects x and z case uniquely.
	  S0: begin
	     //detected <= 1'b1;
	     if (in== 1) n_state = S1;
	     else n_state = S0;
	     
	  end
	  S1: begin
	     //detected <= 1'b1;
	     if(in == 0) n_state = S2;
	     else n_state = S1;
	     
	  end
	  S2: begin
	     //detected <= 1'b1;
	     if(in == 1) n_state = S3;
	     else n_state = S0;
	     
	  end
	  S3: begin
	     // detected <= 1'b1;
       	     if (in == 1) n_state = S1;
	     else
	       n_state = S2;
	  end
	  default: $display("State not present");
	endcase // case (p_state)
	
     end
   
/////////Assertions

   property p_onehot;
      @(posedge clk) (reset) |->
	($countones(n_state) == 1); 
   endproperty
   
   a_onehot: assert property(p_onehot); c_onehot: cover property(p_onehot);

   property s0s1;
     @(posedge clk)(in && p_state == S0) |->  (p_state == S1);
   endproperty

   a_s0s1: assert property (s0s1);
   
	

   

endmodule // seq_detector


module top();

   logic in, clk, reset, detected;
   seq_detector DUT (.reset(reset), .in(in), .clk(clk), .detected(detected));

  always #5 clk = ~clk;   
   initial begin
      clk = 0;
      reset = 0;
      in = 0;
      #10
	reset = 1'b1;
      in = 1'b1;
      #100
	$finish();
      
   end

endmodule // top

   

