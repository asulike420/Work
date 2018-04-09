`ifndef SCOREBOARD__SV
`define SCOREBOARD__SV

`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

class scoreboard extends uvm_scoreboard;
  uvm_analysis_imp_before #(packet, scoreboard) before_export;
  uvm_analysis_imp_after  #(packet, scoreboard) after_export;
  uvm_in_order_class_comparator #(packet) comparator[16];

  `uvm_component_utils(scoreboard)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    before_export = new("before_export", this);
    after_export  = new("after_export", this);
    for (int i=0; i < 16; i++) begin
      comparator[i] = uvm_in_order_class_comparator #(packet)::type_id::create($sformatf("comparator_%0d", i), this);
    end
  endfunction

  virtual function void write_before(packet pkt);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    comparator[pkt.da].before_export.write(pkt);
  endfunction

  virtual function void write_after(packet pkt);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    comparator[pkt.da].after_export.write(pkt);
  endfunction

  virtual function void report();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    foreach (comparator[i]) begin
      `uvm_info("Scoreboard_Report",
        $sformatf("Comparator[%0d] Matches = %0d, Mismatches = %0d",
          i, comparator[i].m_matches, comparator[i].m_mismatches), UVM_MEDIUM);
    end
  endfunction

endclass

`endif

