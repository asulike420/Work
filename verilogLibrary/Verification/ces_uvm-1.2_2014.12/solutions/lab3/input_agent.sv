class input_agent extends uvm_agent;
  `uvm_component_utils(input_agent)

  typedef uvm_sequencer #(packet) packet_sequencer;

  packet_sequencer sqr;
  driver drv;
  virtual router_io vif;
  int               port_id = -1;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    sqr = packet_sequencer::type_id::create("sqr", this);
    drv = driver::type_id::create("drv", this);

    uvm_config_db#(int)::get(this, "", "port_id", port_id);
    uvm_config_db#(virtual router_io)::get(this, "", "vif", vif);

    uvm_config_db#(int)::set(this, "*", "port_id", port_id);
    uvm_config_db#(virtual router_io)::set(this, "*", "vif", vif);
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction: connect_phase
endclass: input_agent
