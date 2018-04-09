`ifndef TOP_ENV__SV
`define TOP_ENV__SV

`include "master_env.sv"
`include "slave_env.sv"
`include "slave_virtual_sequence.sv"
`include "slave_virtual_sequencer.sv"

class top_env extends uvm_env;
  typedef master_env#(uvm_object) master_env_t;

  master_env_t            m_env;
  slave_env               s_env;
  slave_virtual_sequencer v_sqr;

  uvm_analysis_port#(packet_base) generic_req_bus;
  uvm_analysis_port#(packet_base) generic_rsp_bus;

  `uvm_component_utils(top_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);

    m_env  = master_env_t::type_id::create("m_env", this);
    s_env  = slave_env::type_id::create("s_env", this);
    v_sqr  = slave_virtual_sequencer::type_id::create("v_sqr", this);

    uvm_config_db #(uvm_object_wrapper)::set(this, "s_env.agt_8.sqr.main_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "s_env.agt_16.sqr.main_phase", "default_sequence", null);

    uvm_config_db #(uvm_object_wrapper)::set(this, "v_sqr.run_phase", "default_sequence", slave_virtual_sequence::get_type());

    generic_req_bus = new("generic_req_bus", this);
    generic_rsp_bus = new("generic_rsp_bus", this);
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);

    m_env.generic_req_bus.connect(generic_req_bus);
    this.generic_req_bus.connect(s_env.generic_req_bus);

    s_env.generic_rsp_bus.connect(generic_rsp_bus);
    this.generic_rsp_bus.connect(m_env.generic_rsp_bus);

    v_sqr.sqr_8  = s_env.agt_8.sqr;
    v_sqr.sqr_16 = s_env.agt_16.sqr;
  endfunction: connect_phase

endclass: top_env

`endif
