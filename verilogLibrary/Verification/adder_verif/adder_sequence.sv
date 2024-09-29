//-------------------------------------------------------------------------
//						adder_sequence's - www.verificationguide.com
//-------------------------------------------------------------------------

//=========================================================================
// adder_sequence - random stimulus
//=========================================================================
class adder_sequence extends uvm_sequence#(adder_seq_item);

  `uvm_object_utils(adder_sequence)

  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "adder_sequence");
    super.new(name);
  endfunction

  `uvm_declare_p_sequencer(adder_sequencer)

  //---------------------------------------
  // create, randomize and send the item to driver
  //---------------------------------------
  virtual task body();
   repeat(2) begin
    req = adder_seq_item::type_id::create("req");
    wait_for_grant();
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end
  endtask
endclass
//=========================================================================

//=========================================================================
// add_rand_a_sequence - "add_rand_a" type
//=========================================================================
class add_rand_a_sequence extends uvm_sequence#(adder_seq_item);

  `uvm_object_utils(add_rand_a_sequence)

  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "add_rand_a_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.a==1;})
  endtask
endclass
//=========================================================================

//=========================================================================
// add_rand_b_sequence - "add_rand_b" type
//=========================================================================
class add_rand_b_sequence extends uvm_sequence#(adder_seq_item);

  `uvm_object_utils(add_rand_b_sequence)

  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "add_rand_b_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.b==1;})
  endtask
endclass
//=========================================================================

//=========================================================================
// add_ab_sequence - "write" followed by "read"
//=========================================================================
class add_ab_sequence extends uvm_sequence#(adder_seq_item);

  `uvm_object_utils(add_ab_sequence)

  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "add_ab_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.a==1;})
    `uvm_do_with(req,{req.b==1;})
  endtask
endclass
//=========================================================================


//=========================================================================
// add_random_ab_sequence - "write" followed by "read" (sequence's inside sequences)
//=========================================================================
class add_random_ab_sequence extends uvm_sequence#(adder_seq_item);

  //---------------------------------------
  //Declaring sequences
  //---------------------------------------
  write_sequence wr_seq;
  read_sequence  rd_seq;

   `uvm_object_utils(add_random_ab_sequence)

  //---------------------------------------
  //Constructor
  //---------------------------------------
  function new(string name = "add_random_ab_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do(wr_seq)
    `uvm_do(rd_seq)
  endtask
endclass
//=========================================================================
