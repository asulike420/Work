class router_env extends uvm_env;
  `uvm_component_utils(router_env)

  reset_agent   r_agt;
  input_agent   i_agt[16];
  output_agent  o_agt[16];
  ms_scoreboard sb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    r_agt = reset_agent::type_id::create("r_agt", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "r_agt.sqr.reset_phase", "default_sequence", reset_sequence::get_type());

    foreach (i_agt[i]) begin
      i_agt[i] = input_agent::type_id::create($sformatf("i_agt[%0d]", i), this);
      uvm_config_db #(int)::set(this, i_agt[i].get_name(), "port_id", i);
      uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(), ".", "sqr.reset_phase"}, "default_sequence", router_input_port_reset_sequence::get_type());
      uvm_config_db #(uvm_object_wrapper)::set(this, {i_agt[i].get_name(), ".", "sqr.main_phase"}, "default_sequence", packet_sequence::get_type());
    end

    sb = ms_scoreboard::type_id::create("sb", this);

    foreach (o_agt[i]) begin
      o_agt[i] = output_agent::type_id::create($sformatf("o_agt[%0d]", i), this);
      uvm_config_db #(int)::set(this, o_agt[i].get_name(), "port_id", i);
    end
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    foreach (i_agt[i]) begin
      i_agt[i].analysis_port.connect(sb.before_export);
    end
    foreach (o_agt[i]) begin
      o_agt[i].analysis_port.connect(sb.after_export);
    end
  endfunction: connect_phase
endclass: router_env
