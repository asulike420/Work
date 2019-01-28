`ifndef RW_SEQ_ITEM__SV
 `define RW_SEQ_ITEM__SV

class rw_seq_item extends uvm_sequence_item;
   rand bit [3:0] raddr, waddr;
   rand bit [7:0] rdata, wdata;
   rand bit wren, rden;

   `uvm_object_utils_begin(rw_seq_item)
      `uvm_field_int(raddr, UVM_ALL_ON )
      `uvm_field_int(rdata, UVM_ALL_ON)
      `uvm_field_int(waddr, UVM_ALL_ON )
      `uvm_field_int(wdata, UVM_ALL_ON)
      `uvm_field_int(wren, UVM_ALL_ON)
      `uvm_field_int(rden, UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "rw_seq_item");
      super.new(name);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction: new

endclass: rw_seq_item
`endif

