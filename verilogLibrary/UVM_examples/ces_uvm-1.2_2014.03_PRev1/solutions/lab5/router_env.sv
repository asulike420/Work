`ifndef ROUTER_ENV__SV
`define ROUTER_ENV__SV

`include "input_agent.sv"
`include "reset_agent.sv"
`include "router_input_port_reset_sequence.sv"
`include "output_agent.sv"
`include "ms_scoreboard.sv"

// Lab 6 - Task 2, Step 2
//
// Include the virtual reset sequence file.
//
// `include "virtual_reset_sequence.sv"
//
// ToDo
`include "virtual_reset_sequence.sv"


class router_env extends uvm_env;
  reset_agent r_agt;
  input_agent i_agt[16];
  output_agent o_agt[16];
  scoreboard sb;

  // Lab 6 - Task 2, Step 3
  //
  // Declare a virtual_reset_sequencer handle called v_reset_sqr
  //
  // virtual_reset_sequencer  v_reset_sqr;
  //
  // ToDo
  virtual_reset_sequencer  v_reset_sqr;


  `uvm_component_utils(router_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 6 - Task 2, Step 4
    //
    // Construct the virtual sequencer.
    //
    // v_reset_sqr = virtual_reset_sequencer::type_id::create("v_reset_sqr", this);
    //
    // ToDo
    v_reset_sqr = virtual_reset_sequencer::type_id::create("v_reset_sqr", this);


    r_agt = reset_agent::type_id::create("r_agt", this);

    // Lab 6 - Task 2, Step 5
    //
    // In the following existing statement, change the r_agt's sequencer to do nothing at the reset phase by setting "default_sequence"
    // to null.
    //
    // uvm_config_db #(uvm_object_wrapper)::set(this, "r_agt.sqr.reset_phase", "default_sequence", null);
    //
    // The reset sequence execution will be done through the virtual reset sequence in step 7.
    //
    // ToDo
//    uvm_config_db #(uvm_object_wrapper)::set(this, "r_agt.sqr.reset_phase", "default_sequence", reset_sequence::get_type());
    uvm_config_db #(uvm_object_wrapper)::set(this, "r_agt.sqr.reset_phase", "default_sequence", null);


    foreach (i_agt[i]) begin
      i_agt[i] = input_agent::type_id::create($sformatf("i_agt[%0d]", i), this);
      uvm_config_db #(int)::set(this, i_agt[i].get_name(), "port_id", i);
      uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(), ".", "sqr.main_phase"}, "default_sequence", packet_sequence::get_type());

      // Lab 6 - Task 2, Step 6
      //
      // In the following existing statement, change the i_agt's sequencer to do nothing at the reset phase by setting "default_sequence"
      // to null.
      //
      // uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(), ".", "sqr.reset_phase"}, "default_sequence", null);
      //
      // The reset sequence execution will be done through the virtual reset sequence in step 7.
      //
      // ToDo
//      uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(), ".", "sqr.reset_phase"}, "default_sequence", router_input_port_reset_sequence::get_type());
      uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(), ".", "sqr.reset_phase"}, "default_sequence", null);



    end

    // Lab 6 - Task 2, Step 7
    //
    // To execute the virtual reset sequence, configure the virtual sequencer to execute the virtual reset sequence at the reset phase.
    //
    // uvm_config_db #(uvm_object_wrapper)::set(this, "v_reset_sqr.reset_phase", "default_sequence", virtual_reset_sequence::get_type());
    //
    // ToDo
    uvm_config_db #(uvm_object_wrapper)::set(this, "v_reset_sqr.reset_phase", "default_sequence", virtual_reset_sequence::get_type());



    sb = scoreboard::type_id::create("sb", this);

    foreach (o_agt[i]) begin
      o_agt[i] = output_agent::type_id::create($sformatf("o_agt[%0d]", i), this);
      uvm_config_db #(int)::set(this, o_agt[i].get_name(), "port_id", i);
    end

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    foreach (i_agt[i]) begin
      i_agt[i].analysis_port.connect(sb.before_export);


      // Lab 6 - Task 2, Step 8
      //
      // Push each input agent's sequencer onto the virtual sequencer's pkt_sqr queue.
      //
      // v_reset_sqr.pkt_sqr.push_back(i_agt[i].sqr);
      //
      // ToDo
      v_reset_sqr.pkt_sqr.push_back(i_agt[i].sqr);


    end
    foreach (o_agt[i]) begin
      o_agt[i].analysis_port.connect(sb.after_export);
    end

    // Lab 6 - Task 2, Step 9
    //
    // Set the virtual sequencer's r_sqr handle to reference the reset agent's sequencer.
    //
    // v_reset_sqr.r_sqr = this.r_agt.sqr;
    //
    // ToDo
    v_reset_sqr.r_sqr = this.r_agt.sqr;

  endfunction

endclass

`endif
