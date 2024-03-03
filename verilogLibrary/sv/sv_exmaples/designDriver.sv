// Code your testbench here
// or browse Examples


interface if1 (input logic clk);
  
  logic ready;
  logic data;
  //NOTE: cb.data cannot be monitored since it s an output of clocking block.
  initial $monitor("%t ready=%b, cb.ready=%b, data=%b", $time,ready, cb.ready, data);
  
  clocking cb @(posedge clk);
    input  ready;
    output data;
    
  endclocking
    endinterface
    

module top;
  
 logic clk;
  if1 tbif(clk);
  
  initial clk=0;
  always #5 clk = ~clk;
  
  
//RESULT:
//                   0 ready=0, cb.ready=x, data=x
//                   5 ready=0, cb.ready=0, data=0
//                  95 ready=1, cb.ready=0, data=0
//                 105 ready=1, cb.ready=1, data=1
