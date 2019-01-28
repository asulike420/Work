`ifndef ROUTER_ENV__SV
`define ROUTER_ENV__SV

`include "input_agent.sv"
`include "reset_agent.sv"

// Lab 3 - Task 9, Step 2
//
// Include the router_input_port_reset_sequence.sv file
//
// ToDo



class router_env extends uvm_env;
  input_agent i_agt;
  reset_agent r_agt;

  `uvm_component_utils(router_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    i_agt = input_agent::type_id::create("i_agt", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "i_agt.sqr.main_phase", "default_sequence", packet_sequence::get_type());
    
    // Lab 3 - Task 9, Step 3
    //
    // Configure i_agt's sqr to execute router_input_port_reset_sequence at reset_phase:
    //
    // uvm_config_db #(uvm_object_wrapper)::set(this, "i_agt.sqr.reset_phase", "default_sequence", router_input_port_reset_sequence::get_type());
    //
    // ToDo



    r_agt = reset_agent::type_id::create("r_agt", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "r_agt.sqr.reset_phase", "default_sequence", reset_sequence::get_type());

  endfunction

endclass

`endif
