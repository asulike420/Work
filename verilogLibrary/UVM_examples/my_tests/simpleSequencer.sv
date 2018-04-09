//create simple sequence with dispaly

import uvm_pkg::*;
`include "uvm_macros.svh"

class sequence extends uvm_sequence;
   
   `uvm_component_utils_begin(sequence)
   `uvm_component_utils_end
   
   function new(name="", uvm_component parent);
      super.new(name, parent);
      //set auto matic objection.
       set_automatic_phase_objection(1);
   endfunction // new


   task body();
      #10
      $display("%tHello world",$time);
      
      endtask
   
endclass // sequence


class test extends uvm_test;
   
   `uvm_component_utils_begin(test)
   `uvm_component_utils_end
   
   function new(name="", uvm_component parent);
      super.new(name, parent);
   endfunction

   uvm_sequencer sequencer1, sequencer2;

      virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    sequencer = uvm_sequencer::type_id::create("sequencer",this);
    uvm_config_db #(uvm_object_wrapper)::set(this, "sequencer1.main_phase", "default_sequence", ::get_type());

 uvm_config_db #(uvm_object_wrapper)::set(this, "sequencer2.reset_phase", "default_sequence", operation_addition::get_type());
	 
	 
endclass // test


//test class


//module for calling run_test
module top;
   initial run_test();
   
endmodule // top

