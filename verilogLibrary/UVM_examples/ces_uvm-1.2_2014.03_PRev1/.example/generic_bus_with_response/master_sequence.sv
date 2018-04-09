`ifndef MASTER_SEQUENCE__SV
`define MASTER_SEQUENCE__SV

`include "packet.sv"

class master_sequence#(WIDTH=8) extends uvm_sequence #(packet#(WIDTH));
  typedef master_sequence#(WIDTH) this_type;
  `uvm_object_param_utils(this_type)

  bit[WIDTH-1:0] ram[16];
  int valid_address[$];

  const static string type_name = $sformatf("master_sequence#(%0d)", WIDTH);

  virtual function string get_type_name();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    return type_name;
  endfunction: get_type_name

  function new(string name = type_name);
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
    `endif

    // UVM mishandles the name field of a parameterized sequence when the parameterized
    // sequence is executed implicitly via the uvm_config_db.  The name field is incorrectly
    // set to "<unknown>".
    //
    // To correct this, you must manually set the name when the name is detected to be "<unknown>".
    // If not done, the instance name will show up as "<unknown>".

    if (this.get_name() == "<unknown>") begin
      this.set_name(type_name);
    end

  endfunction: new

  virtual task pre_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    `ifdef UVM_VERSION_1_1
      if ((get_parent_sequence() == null) && (starting_phase != null)) begin
        starting_phase.raise_objection(this);
      end
    `endif 
  endtask: pre_start

  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);

    repeat(10) begin
      int address[$];
      #($urandom_range(1,5));
      `uvm_do_with(req, {valid_address.size() == 0 -> kind == WRITE; kind == READ -> address inside valid_address;});
      address = valid_address.find_first() with (item == req.address);
      if (address.size() == 0) begin
        valid_address.push_back(req.address);
      end
    end
  endtask: body

  virtual task post_start();
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    `ifdef UVM_VERSION_1_1
      if ((get_parent_sequence() == null) && (starting_phase != null)) begin
        starting_phase.drop_objection(this);
      end
    `endif 
  endtask: post_start

endclass: master_sequence

`endif
