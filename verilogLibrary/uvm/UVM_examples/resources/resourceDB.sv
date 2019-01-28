`include "uvm_macros.svh"

import uvm_pkg::*;



program test;

   int resource;

initial begin

   uvm_resource_db#(int)::set(null,"dut_vif",dur_if1);
   
   
end   




endprogram // test
   
