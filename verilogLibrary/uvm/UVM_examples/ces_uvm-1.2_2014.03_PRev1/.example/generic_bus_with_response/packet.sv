`ifndef PACKET__SV
`define PACKET__SV

`include "packet_base.sv"

class packet#(D_WIDTH=8, A_WIDTH=4) extends packet_base;
  typedef packet#(D_WIDTH,A_WIDTH) this_type;
  rand bit [D_WIDTH-1:0] data;
  rand bit [A_WIDTH-1:0] address;

  `uvm_object_param_utils_begin(this_type)
    `uvm_field_int(address, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  const static string type_name = $sformatf("packet#(%0d,%0d)", D_WIDTH, A_WIDTH);

  virtual function string get_type_name();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return type_name;
  endfunction

  constraint valid {
    D_WIDTH == 16 -> address[0] == 0;
  }

  function new(string name = type_name);
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual function int get_awidth();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return A_WIDTH;
  endfunction: get_awidth

  virtual function int get_dwidth();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return D_WIDTH;
  endfunction: get_dwidth

  virtual function int get_address();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return address;
  endfunction: get_address

  virtual function int get_data();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return data;
  endfunction: get_data
endclass: packet
`endif

