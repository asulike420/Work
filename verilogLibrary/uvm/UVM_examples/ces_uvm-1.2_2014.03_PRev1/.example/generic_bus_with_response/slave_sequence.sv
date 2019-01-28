`ifndef SLAVE_SEQUENCE__SV
`define SLAVE_SEQUENCE__SV

`include "packet.sv"

class slave_sequence#(WIDTH=8) extends uvm_sequence #(packet#(WIDTH));
  `uvm_declare_p_sequencer(slave_sequencer#(WIDTH))
  typedef slave_sequence#(WIDTH) this_type;
  `uvm_object_param_utils(this_type)

  const static string type_name = $sformatf("slave_sequence#(%0d)", WIDTH);

  virtual function string get_type_name();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    return type_name;
  endfunction

  function new(string name = type_name);
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

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

  virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    forever begin
      p_sequencer.get_req(this, req);
      `uvm_info("REQUEST", {"\n", req.sprint()}, UVM_HIGH);
      case (req.kind)
        packet_base::WRITE : begin
                               p_sequencer.ram_write(req);
                               `uvm_info("WRITE", {"\n", req.sprint()}, UVM_FULL);
                             end
        packet_base::READ  : begin
                               rsp = p_sequencer.ram_read(req);
                               `uvm_info("READ", {"\n", rsp.sprint()}, UVM_FULL);
                               p_sequencer.send_rsp(this, rsp);
                             end
      endcase
    end
  endtask: body

endclass: slave_sequence

`endif
