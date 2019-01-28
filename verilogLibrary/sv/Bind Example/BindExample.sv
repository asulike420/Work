// Code your testbench here
// or browse Examples


module m1(a,b);
  
  output reg a;
  output reg b;
  
  initial
    begin	
      $display("1. in module m1");
    a = 0;
  	b=  0;
  #5 
      $display("2. in module m1");
  	a = 1;
    b = 1;
  #10
      $finish();
  end
  
endmodule

module m2(a, b);
  
 output  reg a;
  output reg b;
  
  initial
    begin	
      $display("1. in module m2");
    a = 0;
  	b=  0;
  #5 
      $display("2. in module m2");
  	a = 1;
    b = 1;
  #10
      $finish();
  end
  
endmodule

module b1(a,b);
  input reg a, b;

  always@(*)
    $display("%t a=%b",$time,a," b=%b", b);

  
endmodule


module b2(a,b);
  input reg a, b;
  always@(*)
    $display("%t a=%b",$time,a," b=%b", b);
endmodule


module tb;
  
  //bind m1 b1 binst();//need to check if 
  //bind m2 b2 binst1();//need to check if 
  bit a, b, a1, b1;
  m1 DUT(a,b);
  m2 DUT1(a1, b1);
  
  bind m1 b1 binst(.a(tb.DUT.a), .b(tb.DUT.b));//need to check if 
  bind m2 b1 binst1(.a(tb.DUT1.a), .b(tb.DUT1.b));//need to check if 
  
endmodule
