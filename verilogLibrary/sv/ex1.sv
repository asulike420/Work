/////////////////////////////////////////////////////////////
//File            : ex1.sv
//Description     :
//                  1. Comment need to closely understand the behavior of the assertion evalution at clock edge. 
//                  2. Below code checks assertion on reg type data . 
//                  3. Assertion evaluation occurs in the Observed region, after all current variable updates complete, but uses sampled values from the Preponed region to evaluate the sequence and property expressions. This means that you can safely use the same clock edge to clock the assertions that you use to update the variables. Assertion evaluation uses the pre-clock values.
//Chapter         : Assertion
//Subsection      : Overlapping and Non-Overlapping Assertions              
//TAGS            :
//Keywords        :
//EDA Playground  :
//                : Add below code to get w/f  
//                   initial
//                     begin
//                       $dumpfile("wave.vcd");
//                       $dumpvars;
//                     end
/////////////////////////////////////////////////////////////


//TB
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

//RESULT
/*
 
 
 */
