`ifndef PACKET_SEQUENCE__SV
`define PACKET_SEQUENCE__SV

`include "packet.sv"

// The packet_sequence class has been modified to extend from packet_sequence_base class.
// The reason for this change is to simplify development of the body() method of the sequence
// by moving the raising and dropping of objections to the base class's pre_start() and
// post_start() methods.
//
// With this modification, the packet_sequence class's body() method no longer needs to
// raise and drop objections. 

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
  // The following fields are added to the sequence class.
  //
  //   int       item_count = 10;
  //   int       port_id    = -1;
  //   bit[15:0] da_enable  = '1;
  //   int       valid_da[$];
  //
  // The intent of the item_count field is to control how many packet objects
  // to create and pass on to the driver per execution of the body() task.
  //
  // The intent of the port_id field is to constrain the packet's source address.
  //
  // The lab DUT has 16 input ports needing to be tested.  Each input agent created
  // to drive a particular port will be assigned a port_id specifying which port it
  // should exercise.  Because of this, the sequence within an input agent when
  // when generating packets need to constrain the packet's source address.
  //
  // The rule for constrainint the source address shall be as follows:
  // If port_id is inside the range of {[0:15]}, then the source address shall be port_id.
  // If port_id is -1 (unconfigured), the source address shall be in the range of {[0:15]}
  // port_id outside the range of {-1, {[0:15]} is not allowed.
  //
  // The intent of the da_enable fields is to enable corresponding destination
  // addresses to be generated.  A value of 1 in a particular bit position will
  // enable the corresponding address as a valid address to generate.  A value of 0
  // prohibit the corresponding address from being generated.
  //
  // Example: if the sequence were to be configured to generate only packets
  // for destination address 3, then the da_enable need to be configured as:
  // 16'b0000_0000_0000_1000
  //
  // Note that the default value is '1, meaning that all addresses are enabled.
  //
  // To simplify the constraint coding, a corresponding set of queue, valid_da
  // is needed.  This queue is populated based on the value of da_enable.
  //
  // Example: if da_enable is 16'b0000_0011_0000_1000, then the valid_da queue
  // will populated with 3, 8 and 9.

  int       item_count = 10;
  int       port_id    = -1;
  bit[15:0] da_enable  = '1;
  int       valid_da[$];


  //
  // The `uvm_object_utils macro takes care of the added fields.
  //
  `uvm_object_utils_begin(packet_sequence)
    `uvm_field_int(item_count, UVM_ALL_ON)
    `uvm_field_int(da_enable, UVM_ALL_ON)
    `uvm_field_queue_int(valid_da, UVM_ALL_ON)
    `uvm_field_int(port_id, UVM_ALL_ON)
  `uvm_object_utils_end

  //
  // The fields listed above can be configured for customized use.
  // 
  // The item_count and da_enable are specific to the sequence.  The appropriate way to
  // retrieve the information from the configuration data base is with the following format:
  //
  // uvm_config_db#(int)::get(null, get_full_name(), "item_count", item_count);
  // uvm_config_db#(bit[15:0])::get(null, get_full_name(), "da_enable", da_enable);
  //
  // Once retrieved, the da_enable will be used to populate the valid_da queue.
  //
  // The port_id is a little different.  For this workshop's labs, you will end up in a future lab
  // with 16 input agents and 16 output agents to handle all of the ports of the DUT.
  //
  // Each agent will be assigned a port_id, dedicating that agent to drive that specific port.
  // If the sequence need access to the agent's configuration settings, the sequence will need to access it
  // through the sequencer with the following format:
  //
  // uvm_sequencer_base my_sqr = get_sequencer(); // retrieves the sequencer handle
  // uvm_config_db#(int)::get(my_sqr.get_parent(), "", "port_id",port_id); // retrieves the port_id from agent's configuration data base
  //
  // The retrieval of the configuration values for the sequence needs to happen before the body() method is executed.
  // A good place to retreive the configuration fields and populate the valid_da queue is in the pre_start() method.
  //
  // To simplify your code development, the code is done for you as follows:
  //
  task pre_start();
    super.pre_start();

    uvm_config_db#(int)::get(get_sequencer(), get_type_name(), "item_count", item_count);
    uvm_config_db#(bit[15:0])::get(get_sequencer(), get_type_name(), "da_enable", da_enable);
    uvm_config_db#(int)::get(get_sequencer().get_parent(), "", "port_id",port_id);
    if (!(port_id inside {-1, [0:15]})) begin
      `uvm_fatal("CFGERR", $sformatf("Illegal port_id value of %0d", port_id));
    end

    valid_da.delete();
    for (int i=0; i<16; i++) begin
      if (da_enable[i]) begin
        valid_da.push_back(i);
      end
    end
  endtask

  function new(string name = "packet_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    //
    // Instead of hard coding the number of item to be generated, replace the
    // hard-coded value 10 in the repeat() statement to use item_count.
    //
    repeat(item_count) begin


      //
      // As stated in the comment at the beginning of the file.  If the port_id is unconfigured (-1)
      // then the legal values for the source address shall be in the range of {[0:15]}.  If the
      // port_id is configured, then the source address shall be port_id.  This will give the test
      // the ability to test whether or not the driver drops the packet it is not configured to drive.
      //
      // For destination address, the legal values should be picked out of the valid_da array.
      //
      `uvm_do_with(req, {if (port_id == -1) sa inside {[0:15]}; else sa == port_id; da inside valid_da;});


    end
 endtask

endclass

`endif
