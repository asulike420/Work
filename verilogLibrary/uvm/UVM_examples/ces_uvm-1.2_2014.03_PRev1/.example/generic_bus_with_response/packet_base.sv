`ifndef PACKET_BASE__SV
`define PACKET_BASE__SV

virtual class packet_base extends uvm_sequence_item;
  typedef enum {READ, WRITE} kind_e;

  rand kind_e      kind;

  virtual function void do_print (uvm_printer printer); 
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
    super.do_print(printer);
    printer.print_generic("kind", "kind_e", $bits(kind), kind.name());
  endfunction: do_print

  function new(string name = "packet_base");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_DEBUG);
  endfunction: new

  pure virtual function int get_awidth();
  pure virtual function int get_dwidth();
  pure virtual function int get_address();
  pure virtual function int get_data();
endclass: packet_base
`endif

