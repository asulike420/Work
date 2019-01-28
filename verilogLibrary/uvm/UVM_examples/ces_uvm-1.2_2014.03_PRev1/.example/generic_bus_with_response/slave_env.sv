`ifndef SLAVE_ENV__SV
`define SLAVE_ENV__SV

`include "slave_agent.sv"
`include "slave_sequence.sv"

class slave_env extends uvm_env;
  typedef slave_agent#(8)  agent_8;
  typedef slave_agent#(16) agent_16;
  agent_8  agt_8;
  agent_16 agt_16;

  uvm_analysis_export#(packet_base) generic_req_bus;
  uvm_analysis_port#(packet_base)   generic_rsp_bus;

  `uvm_component_utils(slave_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    super.build_phase(phase);

    agt_8  = agent_8::type_id::create("agt_8", this);
    agt_16 = agent_16::type_id::create("agt_16", this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "agt_8.sqr.main_phase", "default_sequence", slave_sequence#(8)::get_type());
    uvm_config_db #(uvm_object_wrapper)::set(this, "agt_16.sqr.main_phase", "default_sequence", slave_sequence#(16)::get_type());

    generic_req_bus = new("generic_req_bus", this);
    generic_rsp_bus = new("generic_rsp_bus", this);
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    super.connect_phase(phase);

    this.generic_req_bus.connect(agt_8.drv.generic_req_bus);
    this.generic_req_bus.connect(agt_16.drv.generic_req_bus);

    agt_8.drv.generic_rsp_bus.connect(this.generic_rsp_bus);
    agt_16.drv.generic_rsp_bus.connect(this.generic_rsp_bus);
  endfunction: connect_phase

endclass: slave_env

`endif
