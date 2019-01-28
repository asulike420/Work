`ifndef HOST_SEQUENCE__SV
`define HOST_SEQUENCE__SV

// Host data class access is required.
`include "host_data.sv"


// Lab 6 - Task 9, Step 2
// Include the ral_host_regmodel.sv file
//
// ToDo
`include "ral_host_regmodel.sv"


class host_sequence_base extends uvm_sequence #(host_data);
  `uvm_object_utils(host_sequence_base)

  virtual host_io    vif;
  uvm_sequencer_base p_sqr;

  function new(string name = "host_sequence_base");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction

  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    p_sqr = get_sequencer();

    `ifdef UVM_VERSION_1_1
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.raise_objection(this);
    end
    `endif

    if (uvm_config_db#(virtual host_io)::get(p_sqr.get_parent(), "", "vif", vif)) begin
      `uvm_info("HOST_SEQ_CFG", "Has access to host interface", UVM_HIGH);
    end
  endtask

  `ifdef UVM_VERSION_1_1
  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    if ((get_parent_sequence() == null) && (starting_phase != null)) begin
      starting_phase.drop_objection(this);
    end
  endtask
  `endif

endclass


class host_reset_sequence extends host_sequence_base;
  `uvm_object_utils(host_reset_sequence)

  function new(string name = "host_reset_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual task body();
    vif.wr_n = 1'b1;
    vif.rd_n = 1'b1;
    vif.address ='z;
    vif.data = 'z;
  endtask
endclass

//
// The host_bfm_sequence class is designed to test the DUT registers and memory
// using the host_driver without using RAL.
//
class host_bfm_sequence extends host_sequence_base;
  `uvm_object_utils(host_bfm_sequence)

  function new(string name = "host_bfm_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  // Lab 6 - Task 2, Step 2
  // Develop a body() method that reads and writes the DUT configuration fields
  // with the `uvm_do_with macro by manually specifying the address, data and operation.
  //
  // For this specific task, do the following:
  //
  // Read and check the content of the HOST_ID register at address h0 (The value must be h5A03)
  // Read and check the content of the LOCK register at address h0100 (The value must be hffff after reset)
  // Write all one's (1) to the register to enable all ports
  // Read and check the content of the LOCK register to verify it is now 0
  // Write gray code pattern to the R_ARRAY
  // Read back and check the content of the R_ARRAY for gray code pattern
  // Write walking ones to the RAM
  // Read back and check the content of the RAM for walking ones
  //
  // Uncomment the following code:
  // ToDo

   virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `uvm_do_with(req, {addr == 'h0; kind == UVM_READ;});
    if (req.data != 'h5a03) begin
      `uvm_fatal("BFM_ERR", $sformatf("HOST_ID is %4h instead of 'h5a03", req.data));
    end else begin
      `uvm_info("BFM_TEST", $sformatf("HOST_ID is %4h the expected value is 'h5a03", req.data), UVM_MEDIUM);
    end
  
    `uvm_do_with(req, {addr == 'h100; kind == UVM_READ;});
    if (req.data != '1) begin
      `uvm_fatal("BFM_ERR", $sformatf("LOCK is %4h instead of 'hffff", req.data));
    end
    `uvm_do_with(req, {addr == 'h100; data == '1; kind == UVM_WRITE;});
    `uvm_do_with(req, {addr == 'h100; kind == UVM_READ;});
    if (req.data != '0) begin
      `uvm_fatal("BFM_ERR", $sformatf("LOCK is %4h instead of 'h0000", req.data));
    end else begin
      `uvm_info("BFM_TEST", $sformatf("LOCK is %4h the expected value is 'h0000", req.data), UVM_MEDIUM);
    end
  
    for (int i=0; i<256; i++) begin
      `uvm_do_with(req, {addr == 'h1000+i; data == (i ^ (i >> 1)); kind == UVM_WRITE;});
    end
    for (int i=0; i<256; i++) begin
      `uvm_do_with(req, {addr == 'h1000+i; kind == UVM_READ;});
      if (req.data != (i ^ (i >> 1))) begin
        `uvm_fatal("BFM_ERR", $sformatf("R_ARRAY is %4h instead of %4h", req.data, i ^ (i >> 1)));
      end
    end
    `uvm_info("BFM_TEST", "R_ARRAY contains the expected values", UVM_MEDIUM);
  
    for (int i=0; i<4096; i++) begin
      `uvm_do_with(req, {addr == 'h4000+i; data == 16'b1 << i%16; kind == UVM_WRITE;});
    end
    for (int i=0; i<4096; i++) begin
      `uvm_do_with(req, {addr == 'h4000+i; kind == UVM_READ;});
      if (req.data != 16'b1 << i%16) begin
        `uvm_fatal("BFM_ERR", $sformatf("RAM[%4h] is %4h instead of %4h", i, req.data, 16'b1 << i%16));
      end
    end
    `uvm_info("BFM_TEST", "RAM contains the expected values", UVM_MEDIUM);
  endtask

endclass


//
// The following is the RAL configuration sequence base.  It contains the
// regmodel that the RAL sequences will need.
//

class host_ral_sequence_base extends uvm_reg_sequence #(host_sequence_base);
  `uvm_object_utils(host_ral_sequence_base)

  // Lab 6 - Task 9, Steps 4
  // Create an instance of ral_block_host_regmodel called regmodel.
  //
  // ToDo
  ral_block_host_regmodel regmodel;

  function new(string name = "host_ral_sequence_base");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual task pre_start();
    super.pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 6 - Task 9, Steps 5
    // Get the register model through the uvm_config_db mechanism as follows:
    //
    // if (!uvm_config_db#(ral_block_host_regmodel)::get(p_sqr.get_parent(), "", "regmodel", regmodel)) begin
    //   `uvm_info("RAL_CFG", "regmodel not set through configuration.  Make sure it is set by other mechanisms", UVM_MEDIUM);
    // end
    // if (regmodel == null) begin
    //   `uvm_fatal("RAL_CFG", "regmodel not set");
    // end
    //
    // ToDo
    if (!uvm_config_db#(ral_block_host_regmodel)::get(p_sqr.get_parent(), "", "regmodel", regmodel)) begin
      `uvm_info("RAL_CFG", "regmodel not set through configuration.  Make sure it is set by other mechanisms", UVM_MEDIUM);
    end
    if (regmodel == null) begin
      `uvm_fatal("RAL_CFG", "regmodel not set");
    end

  endtask
endclass

//
// This is the RAL test sequence.
//

class host_ral_test_sequence extends host_ral_sequence_base;
  `uvm_object_utils(host_ral_test_sequence)

  function new(string name = "host_ral_test_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  // Lab 6 - Task 9, Steps 7
  //
  // Define a body() task that configures the DUT register with the exact same information
  // as host_bfm_sequence above.  Except use UVM register representation rather than direct access.
  //
  // For this specific task, do the following:
  //
  // Read and check the content of the HOST_ID register at address h0 (The value must be h5A03)
  // Read and check the content of the LOCK register at address h0100 (The value must be hffff after reset)
  // Write all one's (1) to the register to enable all ports
  // Read and check the content of the LOCK register to verify it is now 0
  // Write gray code pattern to the R_ARRAY
  // Read back and check the content of the R_ARRAY for gray code pattern
  // Write walking ones to the RAM
  // Read back and check the content of the RAM for walking ones
  //
  // Uncomment the following code:
  // ToDo

  virtual task body();
    uvm_status_e status;
    uvm_reg_data_t data;

    regmodel.HOST_ID.read(.status(status), .value(data), .path(UVM_BACKDOOR), .parent(this));

    if (data != 'h5a03) begin
      `uvm_fatal("RAL_ERR", $sformatf("HOST_ID is %4h instead of 'h5a03", data));
    end else begin
      `uvm_info("RAL_TEST", $sformatf("HOST_ID is %4h the expected value is 'h5a03", data), UVM_MEDIUM);
    end

    regmodel.LOCK.read(.status(status), .value(data), .path(UVM_BACKDOOR), .parent(this));

    if (data != 'hffff) begin
      `uvm_fatal("RAL_ERR", $sformatf("LOCK is %4h instead of 'hffff", data));
    end

    regmodel.LOCK.write(.status(status), .value('1), .path(UVM_FRONTDOOR), .parent(this));
    regmodel.LOCK.read(.status(status), .value(data), .path(UVM_BACKDOOR), .parent(this));

    if (data != '0) begin
      `uvm_fatal("RAL_ERR", $sformatf("LOCK is %4h instead of 'h0000", data));
    end else begin
      `uvm_info("RAL_TEST", $sformatf("LOCK is %4h the expected value is 'h0000", data), UVM_MEDIUM);
    end

    for (int i=0; i<256; i++) begin
      regmodel.R_ARRAY[i].write(.status(status), .value(i ^ (i >> 1)), .path(UVM_FRONTDOOR), .parent(this));
    end

    for (int i=0; i<256; i++) begin
      regmodel.R_ARRAY[i].read(.status(status), .value(data), .path(UVM_BACKDOOR), .parent(this));
      if (data != (i ^ (i >> 1))) begin
        `uvm_fatal("RAL_ERR", $sformatf("R_ARRAY is %4h instead of %4h", data, i ^ (i >> 1)));
      end
    end
    `uvm_info("RAL_TEST", "R_ARRAY contains the expected values", UVM_MEDIUM);

    for (int i=0; i<4096; i++) begin
      regmodel.RAM.write(.status(status), .offset(i), .value(16'b1 << i%16), .path(UVM_FRONTDOOR), .parent(this));
    end

    for (int i=0; i<4096; i++) begin
      regmodel.RAM.read(.status(status), .offset(i), .value(data), .path(UVM_BACKDOOR), .parent(this));
      if (data != 16'b1 << i%16) begin
        `uvm_fatal("RAL_ERR", $sformatf("RAM[%4h] is %4h instead of %4h", i, data, 16'b1 << i%16));
      end
    end
    `uvm_info("RAL_TEST", "RAM contains the expected values", UVM_MEDIUM);
  endtask

endclass

  // Lab 6 - Task 14, Steps 2
  //
  // The following sequence using RAL is written for you.  The content is very
  // straight forward.  By writting all one's to the LOCK register, you are
  // unlocking all the router ports.
  //
  // Uncomment the following code:
  // ToDo


class ral_port_unlock_sequence extends host_ral_sequence_base;
  `uvm_object_utils(ral_port_unlock_sequence)

  function new(string name = "ral_port_unlock_sequence");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual task body();
    uvm_status_e status;
    uvm_reg_data_t data;

    regmodel.LOCK.write(.status(status), .value('1), .path(UVM_FRONTDOOR), .parent(this));
  endtask
endclass


`endif
