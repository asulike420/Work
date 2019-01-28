`ifndef __VIRTUAL_SEQUENCE__SV__
 `define __VIRTUAL_SEQUENCE__SV__

class virtual_sequencer extends uvm_sequencer;
   `uvm_component_utils(virtual_sequencer)
   uvm_sequencer#(rw_seq_item)  r_sqr;
  uvm_sequencer#(rw_seq_item) w_sqr;

   function new(string name, uvm_component parent);
      super.new(name, parent);    
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction
endclass

class virtual_sequence extends uvm_sequence;
   `uvm_object_utils(virtual_sequence)
   `uvm_declare_p_sequencer(virtual_sequencer)

   read_seq_c   r_seq;
   write_seq_c  w_seq;

   function new(string name="virtual_sequence");
      super.new(name);    
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

 `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
 `endif
   endfunction

   virtual task body();
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

      //fork
     `uvm_do_on(w_seq, p_sequencer.w_sqr);
      `uvm_do_on(r_seq, p_sequencer.r_sqr);
	
      //join

   endtask

 `ifdef UVM_VERSION_1_1
   virtual task pre_start();
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      if ((get_parent_sequence() == null) && (starting_phase != null)) begin
	 starting_phase.raise_objection(this);
      end
   endtask

   virtual task post_start();
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      if ((get_parent_sequence() == null) && (starting_phase != null)) begin
	 starting_phase.drop_objection(this);
      end
   endtask
 `endif
endclass
`endif //  `ifndef __VIRTUAL_SEQUENCE__SV__

