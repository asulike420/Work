`ifndef SLAVE_DRIVER__SV
`define SLAVE_DRIVER__SV

`include "packet.sv"

class slave_driver#(WIDTH=8) extends uvm_driver #(packet#(WIDTH));
  typedef slave_driver#(WIDTH) this_type;
  `uvm_component_param_utils(this_type)

  uvm_analysis_imp     #(packet_base, this_type)    generic_req_bus;
  uvm_analysis_port    #(packet_base)               generic_rsp_bus;
  uvm_blocking_get_imp #(packet#(WIDTH), this_type) req_export;
  uvm_event                                         bus_event;
  packet#(WIDTH)                                    bus_tr;

  const static string type_name = $sformatf("slave_driver#(%0d)", WIDTH);

  virtual function string get_type_name();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return type_name;
  endfunction

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    generic_req_bus = new("generic_req_bus", this);
    generic_rsp_bus = new("generic_rsp_bus", this);
    bus_event   = new("bus_event");
    req_export  = new("req_export", this);
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    forever begin
      read_bus();
      if (req.kind == packet_base::READ) begin
        seq_item_port.get_next_item(rsp);
        `uvm_info("SDRV_RSP", {"\n", rsp.sprint()}, UVM_MEDIUM);
        generic_rsp_bus.write(rsp);
        seq_item_port.item_done();
      end
    end
  endtask: run_phase

  virtual function void write(packet_base pkt);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    if (pkt.get_dwidth == WIDTH) begin
      `uvm_info("REQ_BUS", {"\n", pkt.sprint()}, UVM_MEDIUM);
      bus_event.trigger(pkt);
    end
  endfunction: write

  // The following emulates a bus transaction
  virtual task read_bus();
    uvm_object tr;
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    bus_event.wait_trigger_data(tr);
    $cast(req, tr);
    bus_tr = req;
  endtask: read_bus

  // The following is the request port to the sequencer
  virtual task get(output packet#(WIDTH) req2sqr);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    wait (bus_tr != null);
    req2sqr = bus_tr;
    bus_tr = null;
  endtask: get

endclass: slave_driver

`endif

