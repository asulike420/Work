interface if_ (input bit clk);
  
  logic i_valid;
  
  clocking cb @(posedge  clk);
    output i_valid;
  endclocking
  
  modport DUT(input clk, i_valid);
  
endinterface

module tester(if_.DUT if1);
  
  reg [4:0] cnt;
  
  initial begin
    cnt = 0;
    $monitor("%t cnt= %d, i_valid=%b",$time,cnt, if1.i_valid);
  end
  
  always @(posedge if1.clk)
    if(if1.i_valid)
    cnt <= cnt+1;
    
endmodule

module top;
  
  reg clk;
  initial clk = 0;
  always #5 clk = ~clk;
  
  if_ if_t(clk);
  tester DUT(if_t);
  
  
  endmodule
  

program test;
  
  virtual if_ vif;
  
  initial 
    vif  = top.if_t;
  
  initial begin
    vif.cb.i_valid <= 1'b0;
    #10
    @vif.cb;
    vif.cb.i_valid <= 1'b1;
    repeat (3) @vif.cb;
  end
  
  
  
endprogram
