`ifndef SLAVE_VIRTUAL_SEQUENCER__SV
`define SLAVE_VIRTUAL_SEQUENCER__SV

`include "packet.sv"

class slave_virtual_sequencer extends uvm_sequencer;
  logic[7:0] ram[16];
  `uvm_component_utils(slave_virtual_sequencer)

  uvm_sequencer#(packet#(8))  sqr_8;
  uvm_sequencer#(packet#(16)) sqr_16;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
endclass: slave_virtual_sequencer

`endif
