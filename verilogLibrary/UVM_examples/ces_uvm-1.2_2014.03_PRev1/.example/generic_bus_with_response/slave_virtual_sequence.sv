`ifndef SLAVE_VIRTUAL_SEQUENCE__SV
`define SLAVE_VIRTUAL_SEQUENCE__SV

`include "packet.sv"
`include "slave_virtual_sequencer.sv"

class slave_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(slave_virtual_sequence)
  `uvm_declare_p_sequencer(slave_virtual_sequencer)

  slave_sequence#(8)  seq_8;
  slave_sequence#(16) seq_16;

  function new(string name="slave_virtual_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    fork
      `uvm_do_on(seq_8, p_sequencer.sqr_8)
      `uvm_do_on(seq_16, p_sequencer.sqr_16)
    join
  endtask: body
endclass: slave_virtual_sequence

`endif
