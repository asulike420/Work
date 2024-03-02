`include "uvm_macros.svh"
import uvm_pkg::*;


class abc extends uvm_sequence_item;

   rand bit [31:0] a;
   rand bit [31:0] b;

   `uvm_object_utils_begin(abc)
      `uvm_field_int(a, UVM_ALL_ON)
      `uvm_field_int(b, UVM_ALL_ON)
   `uvm_object_utils_end

   constraint a_const {
      $countones(a) == 5;
   }

   constraint b_const {
		       for (int i = 0; i<31; i++){
						  if( i != 0)
						  b[i] != b[i-1];
						  }  
   }

   
endclass // abc


module test;

   abc obj;

   initial begin
      obj = new();
      obj.randomize();
      obj.print();
   end


endmodule // test
