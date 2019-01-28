`ifndef MASTER_DRIVER__SV
`define MASTER_DRIVER__SV

`include "packet.sv"

class master_driver#(WIDTH=8) extends uvm_driver #(packet#(WIDTH));
  typedef master_driver#(WIDTH) this_type;
  `uvm_component_param_utils(this_type)

  uvm_analysis_port#(packet_base)           generic_req_bus;
  uvm_analysis_imp#(packet_base, this_type) generic_rsp_bus;

  const static string type_name = $sformatf("master_driver#(%0d)", WIDTH);

  virtual function string get_type_name();
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
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    forever begin
      seq_item_port.get_next_item(req);
      `uvm_info("MDRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
      generic_req_bus.write(req);
      seq_item_port.item_done();
    end
  endtask: run_phase

  virtual function void write(packet_base pkt);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    if (pkt.get_dwidth == WIDTH) begin
      `uvm_info("RSP_BUS", {"\n", pkt.sprint()}, UVM_MEDIUM);
    end
  endfunction: write

endclass: master_driver

`endif

