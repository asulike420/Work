`ifndef INPUT_AGENT__SV
`define INPUT_AGENT__SV

`include "packet_sequence.sv"
`include "driver.sv"
`include "iMonitor.sv"

typedef uvm_sequencer #(packet) packet_sequencer;

class input_agent extends uvm_agent;
  packet_sequencer            sqr;
  driver                      drv;
  virtual router_io           vif;
  int                         port_id = -1;
  iMonitor                    mon;
  uvm_analysis_port #(packet) analysis_port;

  `uvm_component_utils(input_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    if (is_active == UVM_ACTIVE) begin
      sqr = packet_sequencer::type_id::create("sqr", this);
      drv = driver::type_id::create("drv", this);
    end

    mon = iMonitor::type_id::create("mon", this);

    analysis_port = new("analysis_port", this);

    uvm_config_db#(int)::get(this, "", "port_id", port_id);
    uvm_config_db#(virtual router_io)::get(this, "", "vif", vif);

    uvm_config_db#(int)::set(this, "*", "port_id", port_id);
    uvm_config_db#(virtual router_io)::set(this, "*", "vif", vif);

  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sqr.seq_item_export);
    end

    mon.analysis_port.connect(this.analysis_port);
  endfunction: connect_phase
endclass: input_agent

`endif
