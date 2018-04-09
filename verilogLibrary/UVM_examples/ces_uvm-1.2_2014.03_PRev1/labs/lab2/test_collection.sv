`ifndef TEST_COLLECTION__SV
`define TEST_COLLECTION__SV

`include "router_env.sv"

class test_base extends uvm_test;
  `uvm_component_utils(test_base)

  router_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    env = router_env::type_id::create("env", this);
  endfunction: build_phase


  // There is a modification to where the print topology and the factory print is called.
  //
  // It was in the start_of_simulation_phase in the previous lab.  For
  // your own project testbench, that's where it should be.  However, for
  // the convinience of looking up the available test classes in the labs,
  // these two print calls are move to the final_phase.

  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "TOPOLOGY")) begin
      uvm_root::get().print_topology();
    end

    if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "FACTORY")) begin
      uvm_factory::get().print();
    end
  endfunction: final_phase
endclass: test_base


// Lab 2: Task 6, Step 2 - Use the Verilog include compiler directive
// to bring in the packet_da_3.sv file
//
// ToDo




// The following test uses instance override to set the constraint for destination address to 3.

class test_da_3_inst extends test_base;
  `uvm_component_utils(test_da_3_inst)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 2: Task 6, Step 3 - Use instance override to replace packet with packet_da_3.
    //
    // set_inst_override_by_type("env.i_agt.sqr.packet_sequence.req", packet::get_type(), packet_da_3::get_type());
    //
    // ToDo


  endfunction
endclass

`endif
