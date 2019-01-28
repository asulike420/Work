`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV

class scoreboard extends uvm_scoreboard;
 
  // Lab 4 - Task 6, Step 2 & 3
  //
  // Use typedef to create a substitute name for a uvm_in_order_class_comparator class
  // parameterized to packet, calling it packet_cmp.  This will simplify the code that
  // you type later when you construct the object.
  //
  // Then, declare an instance of packet_cmp, calling it comparator.
  //
  // typedef uvm_in_order_class_comparator #(packet) packet_cmp;
  // packet_cmp comparator;
  //
  // ToDo



  // Lab 4 - Task 6, Step 4
  //
  // Create two uvm_analysis_export, one called before_export and the other after_export.
  //
  // ToDo




  `uvm_component_utils(scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    // Lab 4 - Task 6, Step 5
    //
    // Construct the comparator and the two pass-through analysis exports.
    //
    // comparator = packet_cmp::type_id::create("comparator", this);
    // before_export = new("before_export", this);
    // after_export  = new("after_export", this);
    //
    // ToDo




  endfunction


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Lab 4 - Task 6, Step 6
    //
    // Connect the two pass-through analysis exports to the comparator's exports.
    //
    // this.before_export.connect(comparator.before_export);
    // this.after_export.connect(comparator.after_export); 
    //
    // ToDo




  endfunction


  //
  // You should always print the comparison results in the report phase.
  // This is done for you.
  //
  virtual function void report_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    `uvm_info("Scoreboard_Report",
      $sformatf("Comparator Matches = %0d, Mismatches = %0d", comparator.m_matches, comparator.m_mismatches), UVM_MEDIUM);
  endfunction

endclass

`endif

