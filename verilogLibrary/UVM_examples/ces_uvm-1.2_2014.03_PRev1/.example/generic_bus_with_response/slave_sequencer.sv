`ifndef SLAVE_SEQUENCER__SV
`define SLAVE_SEQUENCER__SV

`include "packet.sv"

class slave_sequencer#(WIDTH=8) extends uvm_sequencer#(packet#(WIDTH));
  typedef slave_sequencer#(WIDTH) this_type;
  `uvm_component_param_utils(this_type)
  uvm_blocking_get_port#(packet#(WIDTH)) req_port;
  logic[WIDTH-1:0] ram[16];

  const static string type_name = $sformatf("slave_sequencer#(%0d)", WIDTH);

  virtual function string get_type_name();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return type_name;
  endfunction

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    req_port = new("req_port", this);
  endfunction: build_phase

  virtual task get_req(uvm_sequence_base seq, output packet#(WIDTH) req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    req_port.get(req);
  endtask: get_req

  virtual task send_rsp(uvm_sequence_base seq, packet_base rsp);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    rsp.set_item_context(seq);
    wait_for_grant(seq);
    seq.finish_item(rsp);
  endtask: send_rsp

  virtual function void ram_write(packet_base req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    `uvm_info("RAM_WRITE", {"\n", req.sprint()}, UVM_DEBUG);
    ram[req.get_address()] = req.get_data();
  endfunction: ram_write

  virtual function packet#(WIDTH) ram_read(packet_base req);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    ram_read = packet#(WIDTH)::type_id::create("ram_read", this);
    ram_read.address = req.get_address();
    ram_read.data = ram[req.get_address()];
    `uvm_info("RAM_READ", {"\n", ram_read.sprint()}, UVM_DEBUG);
  endfunction: ram_read
endclass: slave_sequencer

`endif
