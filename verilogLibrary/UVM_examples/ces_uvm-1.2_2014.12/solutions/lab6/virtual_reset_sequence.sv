class virtual_reset_sequence extends uvm_sequence;
  `uvm_object_utils(virtual_reset_sequence)
  `uvm_declare_p_sequencer(virtual_reset_sequencer)

  reset_sequence                    r_seq;
  router_input_port_reset_sequence  i_seq;
  uvm_event reset_event = uvm_event_pool::get_global("reset");

  // Lab 6 - Task 4, Step 5
  //
  // In this virtual sequence you will need to add one more sequence execution: host_reset_sequence
  //
  // Create a host_reset_sequence handle called h_seq
  //
  // host_reset_sequence    h_seq;
  //
  // ToDo
  host_reset_sequence    h_seq;


  function new(string name="virtual_reset_sequence");
    super.new(name);    
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction: new

  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    fork
      `uvm_do_on(r_seq, p_sequencer.r_sqr);
      foreach (p_sequencer.pkt_sqr[i]) begin
        int j = i;
        fork
          begin
            reset_event.wait_on();
            `uvm_do_on(i_seq, p_sequencer.pkt_sqr[j]);
          end
        join_none
      end

      // Lab 6 - Task 4, Step 6
      //
      // This virtual sequence need to execute one more sequence when reset
      // is detected: the host_reset_sequence,
      //
      // begin
      //   reset_event.wait_on();
      //   `uvm_do_on(h_seq, p_sequencer.h_sqr);
      // end
      //
      // ToDo
      begin
        reset_event.wait_on();
        `uvm_do_on(h_seq, p_sequencer.h_sqr);
      end


    join
  endtask: body

  `ifdef UVM_VERSION_1_1
  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
  endtask: pre_start

  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask: post_start
  `endif
endclass: virtual_reset_sequence
