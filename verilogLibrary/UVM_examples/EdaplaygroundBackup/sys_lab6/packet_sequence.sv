`ifndef PACKET_SEQUENCE__SV
`define PACKET_SEQUENCE__SV

`include "packet.sv"

class packet_sequence_base extends uvm_sequence #(packet);
  `uvm_object_utils(packet_sequence_base)

  function new(string name = "packet_sequence_base");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction

  `ifdef UVM_VERSION_1_1
  virtual task pre_start();
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask

  virtual task post_start();
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask
  `endif
endclass

class packet_sequence extends packet_sequence_base;
  int       item_count = 10;
  bit[15:0] da_enable  = '1;
  int       valid_da[$];
  int       port_id    = -1;

  `uvm_object_utils_begin(packet_sequence)
    `uvm_field_int(item_count, UVM_ALL_ON)
    `uvm_field_int(da_enable, UVM_ALL_ON)
    `uvm_field_queue_int(valid_da, UVM_ALL_ON)
    `uvm_field_int(port_id, UVM_ALL_ON)
  `uvm_object_utils_end

  task pre_start();
    super.pre_start();
    begin
      uvm_sequencer_base my_sqr = get_sequencer();

      uvm_config_db#(int)::get(null, get_full_name(), "item_count", item_count);
      uvm_config_db#(bit[15:0])::get(null, get_full_name(), "da_enable", da_enable);
      uvm_config_db#(int)::get(my_sqr.get_parent(), "", "port_id",port_id);
      if (!(port_id inside {-1, [0:15]})) begin
        `uvm_fatal("CFGERR", $sformatf("Illegal port_id value of %0d", port_id));
      end

      valid_da.delete();
      for (int i=0; i<16; i++) begin
        if (da_enable[i]) begin
          valid_da.push_back(i);
        end
      end
    end
  endtask

  function new(string name = "packet_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    repeat(item_count) begin
      `uvm_do_with(req, {if (port_id == -1) sa inside {[0:15]}; else sa == port_id; da inside valid_da;});
    end
 endtask

endclass

`endif
