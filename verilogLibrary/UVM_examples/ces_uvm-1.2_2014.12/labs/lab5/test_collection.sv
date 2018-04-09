class test_base extends uvm_test;
  `uvm_component_utils(test_base)

  router_env env;
  virtual router_io router_vif;
  virtual reset_io  reset_vif;

  // Lab 5 - Task 2, Step 2
  //
  // Declare a virtual_reset_sequencer handle called v_reset_sqr
  //
  // virtual_reset_sequencer  v_reset_sqr;
  //
  // ToDo



  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    env = router_env::type_id::create("env", this);

    uvm_resource_db#(virtual router_io)::read_by_type("router_vif", router_vif, this);
    uvm_resource_db#(virtual reset_io)::read_by_type("reset_vif", reset_vif, this);

    uvm_config_db#(virtual router_io)::set(this, "env.i_agt[*]", "vif", router_vif);
    uvm_config_db#(virtual router_io)::set(this, "env.o_agt[*]", "vif", router_vif);
    uvm_config_db#(virtual reset_io)::set(this, "env.r_agt", "vif", reset_vif);

    // Lab 5 - Task 2, Step 3
    //
    // Construct the virtual sequencer.
    //
    // v_reset_sqr = virtual_reset_sequencer::type_id::create("v_reset_sqr", this);
    //
    // ToDo



    // Lab 5 - Task 2, Step 4
    //
    // The reset agent was configured by the environment to execute the reset sequence.
    // Since you are now managing the reset sequence execution through the virtural sequencer,
    // you will need to undo the configuration done by the environment.  This is easily achieve
    // by setting configuration database content for the sequencer to null.
    //
    // uvm_config_db #(uvm_object_wrapper)::set(this, "env.r_agt.sqr.reset_phase", "default_sequence", null);
    //
    // ToDo



    // Lab 5 - Task 2, Step 5
    //
    // Do the same thing for the input agents.
    //
    // uvm_config_db #(uvm_object_wrapper)::set(this, "env.i_agt[*].sqr.reset_phase", "default_sequence", null);
    //
    // ToDo



    // Lab 5 - Task 2, Step 6
    //
    // To execute the virtual reset sequence, configure the virtual sequencer to execute the virtual reset sequence at the reset phase.
    //
    // uvm_config_db #(uvm_object_wrapper)::set(this, "v_reset_sqr.reset_phase", "default_sequence", virtual_reset_sequence::get_type());
    //
    // ToDo


  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 5 - Task 2, Step 7
    //
    // Push each input agent's sequencer onto the virtual sequencer's pkt_sqr queue.
    //
    // foreach (env.i_agt[i]) begin
    //   v_reset_sqr.pkt_sqr.push_back(env.i_agt[i].sqr);
    // end
    //
    // ToDo





    // Lab 5 - Task 2, Step 8
    //
    // Set the virtual sequencer's r_sqr handle to reference the reset agent's sequencer.
    //
    // v_reset_sqr.r_sqr = env.r_agt.sqr;
    //
    // ToDo



  endfunction: connect_phase


  virtual task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    phase.raise_objection(this);
    env.sb.wait_for_done();
    phase.drop_objection(this);
  endtask: shutdown_phase

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
    packet_sequence::int_q_t valid_da = {3};
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    // The following has been changed from previous lab to configure all agents
    uvm_config_db#(packet_sequence::int_q_t)::set(this, "env.i_agt[*].sqr.packet_sequence", "valid_da", valid_da);
    uvm_config_db#(int)::set(this, "env.i_agt[*].sqr.packet_sequence", "item_count", 20);
  endfunction: build_phase
endclass: test_da_3_seq
