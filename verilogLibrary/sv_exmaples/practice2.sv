// Code your testbench here
// or browse Examples
//TAGS:: coverage, assertion, print coverage

module top;
  
  logic req, grant;
  logic clk;
  int tr_obj;
       reg reset;

  Check_assert: assert property (@(posedge clk) req |-> ##1 grant)$display("Asserted at time %t",$time);
   Check_cover: cover property  (@(posedge clk) req |-> ##1 grant);
    
     
     covergroup cg @(posedge clk);
       coverpoint tr_obj iff(!reset){
         bins a = (0[->2:4]=>1);
         bins b = (3=>4=>5);
         
       }
       
     endgroup
     
     cg cg_inst;
     int covered, total;
     
     initial begin
       cg_inst = new();
       tr_obj = 0;
       reset = 0;
       @(posedge clk)
       tr_obj = 0;
       @(posedge clk)
       tr_obj =1;
       @(posedge clk)
       cg_inst.get_coverage(covered,total);
       $display("covered = %d , total = %d", covered, total);
     end
     
     
  initial clk = 0;
     always #5 clk = ~clk;
     
     always @(posedge clk) grant <= req;
     
     initial begin
       req <= 0;
       @(posedge clk) 
       req <= 1;
       @(posedge clk)
       req <= 0;
       
     end
     
  
endmodule 
