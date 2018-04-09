// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples


interface ifCheck(input logic clk);
  
logic a ;
  logic b;
  
  clocking cb @(posedge clk);
    output a;
    input b;
  endclocking
  
  modport dut(output b);
  
  initial $monitor("%t a= %0b : cb.b = %0b : b = %0b", $time ,a, cb.b, b);
  
endinterface



module top;
  
  logic clk;
  ifCheck if1(clk);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    if1.cb.a <= 0;
    repeat (3) @if1.cb;
    if1.cb.a <= 1;
    #50 $finish();
  end
  
  initial begin 
    if1.b <= 0;
    @if1.cb;
    if1.b <=1;
  end
  
  initial begin 
    $dumpfile("sap.vcd");
    $dumpvars();
    
  end
  
  
endmodule
