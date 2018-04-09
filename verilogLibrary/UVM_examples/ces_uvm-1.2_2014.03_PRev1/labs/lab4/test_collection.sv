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

    // Lab 4 - Task 4, Step 7
    //
    // In the environment, the input agent has changed from a single instance to an array of 16
    // agents.  Within the test, the corresponding change also must take place.
    //
    // Change the configuration for the input agent objects to the following:
    //
    // uvm_config_db#(virtual router_io)::set(this, "env.i_agt[*]", "vif", router_test_top.router_if);
    //
    // ToDo
    uvm_config_db#(virtual router_io)::set(this, "env.i_agt", "vif", router_test_top.router_if);


    // Lab 4 - Task 7, Step 8
    //
    // In the environment, an array of output agent has been added.  Each of these agents need to
    // access the physical signal.  Configure the agents as follows:
    //
    // uvm_config_db#(virtual router_io)::set(this, "env.o_agt[*]", "vif", router_test_top.router_if);
    //
    // ToDo



    uvm_config_db#(virtual reset_io)::set(this, "env.r_agt", "vif", router_test_top.reset_if);
  endfunction: build_phase

  virtual task main_phase(uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 4 - Task 8, Step 4
    //
    // Retrieve the objection handle for the phase, then set drain time to 1us:
    //
    // objection = phase.get_objection();
    // objection.set_drain_time(this, 1us);
    //
    // ToDo
 


  endtask: main_phase

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

`include "packet_da_3.sv"

class test_da_3_inst extends test_base;
  `uvm_component_utils(test_da_3_inst)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    // The following has been changed from previous lab to configure all agents
    set_inst_override_by_type("env.i_agt[*].sqr.*", packet::get_type(), packet_da_3::get_type());
  endfunction: build_phase
endclass: test_da_3_inst

class test_da_3_type extends test_base;
  `uvm_component_utils(test_da_3_type)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    set_type_override_by_type(packet::get_type(), packet_da_3::get_type());
  endfunction: build_phase
endclass: test_da_3_type

class test_da_3_seq extends test_base;
  `uvm_component_utils(test_da_3_seq)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    // The following has been changed from previous lab to configure all agents
    uvm_config_db#(bit[15:0])::set(this, "env.i_agt[*].sqr.packet_sequence", "da_enable", 16'h0008);
    uvm_config_db#(int)::set(this, "env.i_agt[*].sqr.packet_sequence", "item_count", 20);
  endfunction: build_phase
endclass: test_da_3_seq

`endif

