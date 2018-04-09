
module check(flag);
  
  input flag;
  
  initial $monitor("%t flag = %b", $time , flag);
  
endmodule

interface if_ ;
  
  logic flag;
  
endinterface


module  top;

  if_ if1();
  check DUT(.flag(if1.flag));
  
endmodule


program test;

 virtual if_ vif;
  initial begin
    vif = top.if1;
    vif.flag <= 1'b1;
    #10
    vif.flag <= 1'b0;
  end
  
endprogram

