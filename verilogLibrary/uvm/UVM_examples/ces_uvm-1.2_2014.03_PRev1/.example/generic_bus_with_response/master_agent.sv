`ifndef MASTER_AGENT__SV
`define MASTER_AGENT__SV

`include "packet.sv"
`include "master_driver.sv"

class master_agent#(WIDTH=8) extends uvm_agent;
  typedef master_agent#(WIDTH) this_type;
  `uvm_component_param_utils(this_type)

  const static string type_name = $sformatf("master_agent#(%0d)", WIDTH);

  virtual function string get_type_name();
    return type_name;
  endfunction

  typedef uvm_sequencer#(packet#(WIDTH)) pkt_sequencer;
  typedef master_driver#(WIDTH)          pkt_driver;
  pkt_sequencer sqr;
  pkt_driver    drv;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    sqr = pkt_sequencer::type_id::create("sqr", this);
    drv = pkt_driver::type_id::create("drv", this);
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction: connect_phase
endclass: master_agent

`endif
