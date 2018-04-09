`ifndef TEST_COLLECTION__SV
`define TEST_COLLECTION__SV

`include "top_env.sv"

class test_base extends uvm_test;
  `uvm_component_utils(test_base)
  top_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    env = top_env::type_id::create("env", this);
  endfunction

  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    uvm_root::get().print_topology();
    uvm_factory::get().print();
  endfunction
endclass

`endif

