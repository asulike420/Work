// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

/*
* Input to DUT through clocking block is dealyed by 1 cycle. As the data is driven after the clock edge.
 
 
 
*/ 
interface ifCheck(input logic clk);
   
   logic a ;//Dut i/p
   logic b ;//Dut o/p


   clocking cb_dut @(posedge clk);
      output b;   
      input  a;
   endclocking

   modport dut(input a, output b);
   
   initial $monitor("%t a= %0b : cb.b = %0b : b = %0b", $time ,a, cb.b, b);
   
endinterface



module top;
   
   logic clk;
   ifCheck if1(clk);
   
   initial clk = 0;
   always #5 clk = ~clk;
   
   //VIP drive
   initial begin
      if1.cb.a <= 0;
      repeat (3) @if1.cb;
      if1.cb.a <= 1;
      #50 $finish();
   end

   //DUT drive
   initial begin 
      if1.b <= 0;
      @if1.cb;
      if1.b <= 1;
   end

   initial
     forever
       @if1.cb $display("%t, b = %b, cb.b = %b, a = %b, cb.a = %b", if1.b, if1.cb.b, if1.a, if1.cb.a);
   
   
   initial begin 
      $dumpfile("sap.vcd");
      $dumpvars();
      
   end
   
   
endmodule
