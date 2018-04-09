// Code your testbench here
// or browse Examples
/* Threads spawnwd inside fork - join thread executes parallely . And and will use smae value of shared variable.*/

program test;
  
  
initial
 begin
   
   for (int i = 14; i >= 10; i=i-2)
     begin
       fork
         //auto(i);
         
        $display("%t i=%d",$time, i);
       join_none
     end 
   
 end
  
  
  task auto (ref int i);
  begin
    #2
    $display("%t i=%d",$time, i);
  end
  endtask
endprogram



   
