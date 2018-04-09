`ifndef __VIRTUAL_RESET_SEQUENCE__SV__
`define __VIRTUAL_RESET_SEQUENCE__SV__

`include "reset_agent.sv"
`include "input_agent.sv"

//
// The following virtual sequencer has been created for your in order to save lab time.
//
// A virtual sequencer typically only contains a list of sequencers needed to be managed
// by the virtual sequence.
//
// In this particular case, there are two sequencer types that need to be managed:
// reset_sequencer and packet_sequencer.  Within the test component structure, there is
// only one reset_sequencer but multiple packet_sequencers.  Because of that, a queue
// of packet_sequencers is declared.
//
 
class virtual_reset_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_reset_sequencer)

  typedef uvm_sequencer#(reset_tr) reset_sequencer;
  typedef uvm_sequencer#(packet) packet_sequencer;

  reset_sequencer  r_sqr;
  packet_sequencer pkt_sqr[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);    
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction
endclass


//
// The following is the virtual sequence that you will need to populate to
// manage the reset sequence execution order.
//

class virtual_reset_sequence extends uvm_sequence;
  `uvm_object_utils(virtual_reset_sequence)

  // Lab 5 - Task 1, Step 4
  //
  // Use the `uvm_declare_p_sequencer macro to make the sequencer declared
  // above the parent sequencer type of this sequence.
  //
  // `uvm_declare_p_sequencer(virtual_reset_sequencer)
  //
  // ToDo



  // Lab 5 - Task 1, Step 5
  //
  // In this virtual sequence you will need to manage two types of sequence
  // execution: reset_sequence and router_input_port_reset_sequence.
  //
  // Create a handle of each type here.  Call the reset_sequence handle r_seq
  // And call the router_input_port_reset_sequence handle i_seq.
  //
  // reset_sequence                    r_seq;
  // router_input_port_reset_sequence  i_seq;
  //
  // ToDo




  // Lab 5 - Task 4, Step 6
  //
  // Add the "reset" uvm_event singleton object to the class.
  //
  // uvm_event reset_event = uvm_event_pool::get_global("reset");
  //
  // ToDo


  function new(string name="virtual_reset_sequence");
    super.new(name);    
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction

  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 5 - Task 1, Step 6
    //
    // This virtual sequence need to execute the reset_sequence first,
    // followed by the execution of the router_input_port_reset_sequence.
    //
    // Code the following:  (Code it as shown.  Don't worry if you disagree
    // with the implementation.  It is done this way with a reason.)
    //
    // `uvm_do_on(r_seq, p_sequencer.r_sqr);
    // foreach (p_sequencer.pkt_sqr[i]) begin
    //   `uvm_do_on(i_seq, p_sequencer.pkt_sqr[i]);
    // end
    //
    // ToDo




    // Lab 5 - Task 3, Step 2
    //
    // Comment out the above code.
    //
    // Then, replace the code with the following:
    //
    // fork
    //   `uvm_do_on(r_seq, p_sequencer.r_sqr);
    //   foreach (p_sequencer.pkt_sqr[i]) begin
    //     int j = i;
    //     fork
    //       `uvm_do_on(i_seq, p_sequencer.pkt_sqr[j]);
    //     join_none
    //   end
    // join
    //
    // ToDo





    // Lab 5 - Task 4, Step 7
    //
    // Comment out the above code.
    //
    // Then, replace the code with the following:
    //
    // fork
    //   `uvm_do_on(r_seq, p_sequencer.r_sqr);
    //   foreach (p_sequencer.pkt_sqr[i]) begin
    //     int j = i;
    //     fork
    //       begin
    //         reset_event.wait_on();
    //         `uvm_do_on(i_seq, p_sequencer.pkt_sqr[j]);
    //       end
    //     join_none
    //   end
    // join
    //
    // ToDo








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
`endif
