// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples





class coverCheck;
  
  bit [3:0] myCoverPoint;
    
  covergroup myCoverGroup;
    
    coverpoint myCoverPoint;
    
  endgroup
  
  
  function new();
    
     myCoverGroup= new; // instance name of the covergoup should match with the instnce name
    
  endfunction
  
endclass



program test;
  
  coverCheck ck;
  
  initial begin
    
    ck = new;
    ck.myCoverPoint = 4'd8;
    ck.myCoverGroup.sample();
 	
  end
  
endprogram

