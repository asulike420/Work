// Code your testbench here
// or browse Examples


//Comment need to closely understand the behavior of the assertion evalution at clock edge. 
//Below code checks assertion on reg type data . 
//Assertion evaluation occurs in the Observed region, after all current variable updates complete, but uses sampled values from the Preponed region to evaluate the sequence and property expressions. This means that you can safely use the same clock edge to clock the assertions that you use to update the variables. Assertion evaluation uses the pre-clock values.




module test;
  
  logic req, grant;
  reg clk;
  initial $monitor("%t grant=%d, req=%d",$time ,grant, req);
  overlaping: assert property (@(posedge clk)  req  |->  grant);
    nonOverlaping : assert property (@(posedge clk) req |=> grant);
      
      always @(posedge clk)
      	     	       grant <= req;
      
      initial clk = 0;
      always #1 clk = ~clk;
      
      initial begin
        req <= 0;
        @(posedge clk) req <= 1;
       #50
        $finish();
      end
      
  
endmodule


// Code your testbench here
// or browse Examples

module test;
  
  logic req, grant , check;
  reg clk;
  initial $monitor("%t grant=%d, req=%d",$time ,grant, req);
  overlaping: assert property (@(posedge clk)  req  |->  grant);
    //nonOverlaping : assert property (@(posedge clk) ##1req |=> grant ##1 check);
      
      //always @(posedge clk)
      	       		 //grant <= req;
      
      initial clk = 0;
      always #1 clk = ~clk;
      
      initial begin
        req <= 0; check <= 0;grant <=0;
       // @(posedge clk)
        @(posedge clk) req <= 1; @(posedge clk) grant <=1; req <=0;
        @(posedge clk) check <=1;
       #50
        $finish();
      end
      
  
endmodule