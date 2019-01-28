// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples





class coverCheck;
  
  bit [3:0] myCoverPoint;
    
  covergroup myCoverGroup;
    
    coverpoint myCoverPoint{
       bins a = {[0:10]};
       bins b = {[11:20]};
    }
  endgroup
  
  
  function new();
    
     myCoverGroup= new; // instance name of the covergoup should match with the instnce name
    
  endfunction
  
endclass



program test;
  
  coverCheck ck1, ck2;
  
  initial begin
     int covered, total;
     
    ck1 = new;
     ck2 = new;
     
    ck1.myCoverPoint = 4'd8;
    ck1.myCoverGroup.sample();
     ck2.myCoverPoint = 4'd15;
    ck2.myCoverGroup.sample();
     ck1.myCoverGroup.get_coverage(covered,total);
     $display("covered = %d , total = %d", covered, total);
     ck2.myCoverGroup.get_coverage(covered,total);
     $display("covered = %d , total = %d", covered, total);	
  end
  
endprogram

