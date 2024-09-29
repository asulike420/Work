
class adder_seq_item extends uvm_seq_item;

   bit [31:0] a, b;
   bit [31:0] sum;

   `uvm_object_utils_begin(operands)
      `uvm_field_int(a, UVM_ALL_ON)
      `uvm_field_int(b, UVM_ALL_ON)
      `uvm_field_int(sum, UVM_ALL_ON)
   `uvm_object_utils_end

endclass // operands
