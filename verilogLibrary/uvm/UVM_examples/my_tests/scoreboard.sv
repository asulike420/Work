
 import uvm_pkg::*;
`include "uvm_macros.svh"


typedef class rx_mon;
  typedef class tx_mon;
    typedef class my_sb;

      
      
      class packet extends uvm_sequence_item;
  
        
          function new(string name = "packet");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
        
        
  rand logic [31:0] addr;
  rand logic [31:0] data;
  rand logic wren, rden;
  
  
  function void  pre_randomize();
    $display("Pre_randomizre");
  endfunction
    function void  post_randomize();
      $display("Post_randomizre");
    endfunction
  
  constraint RdWr {if(wren) rden==0;	 
                  else rden==1;}
  
  constraint addCon{ addr < 2; addr>0	;}
  constraint datacon { data < 5; data>0	;}
	  
endclass


module top;
  
  initial run_test("my_test");
  
endmodule



class my_test extends uvm_test;
  
  `uvm_component_utils(my_test)
  my_sb mysb;
  tx_mon txmon;
  rx_mon rxmon;
  
    function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
  
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    
        mysb = my_sb::type_id::create("mysb", this);
    txmon = tx_mon::type_id::create("txmon",this);
    rxmon = rx_mon::type_id::create("rxmon",this);
     endfunction: build_phase 
  
    virtual function void connect_phase(uvm_phase phase);
       `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      txmon.analysis_port.connect(mysb.before_export);
      rxmon.analysis_port.connect(mysb.after_export);
      
  endfunction: connect_phase

  
  
  
  
    
  
endclass


class tx_mon extends uvm_monitor;
  `uvm_component_utils(tx_mon)
   uvm_analysis_port #(packet) analysis_port;
  
  	  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
  
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  analysis_port = new("analysis_port", this);
  endfunction: build_phase
  
    virtual task run_phase(uvm_phase phase);
      packet pkt;
      repeat (10) begin       
           //tr = packet::type_id::create("tr", this);
        pkt = new();
        assert(pkt.randomize);
        `uvm_info("Got_Input_Packet", {"\n", pkt.sprint()}, UVM_MEDIUM);
        analysis_port.write(pkt);

    end
  endtask: run_phase
endclass 



class rx_mon extends uvm_monitor;
  
  `uvm_component_utils(rx_mon)
    uvm_analysis_port #(packet) analysis_port;
  
  	  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
  
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  analysis_port = new("analysis_port", this);
  endfunction: build_phase
  
    virtual task run_phase(uvm_phase phase);
      packet pkt;
      repeat (10) begin       
           //tr = packet::type_id::create("tr", this);
        pkt = new();
        assert(pkt.randomize);
        `uvm_info("Got_Input_Packet", {"\n", pkt.sprint()}, UVM_MEDIUM);
        analysis_port.write(pkt);

    end
  endtask: run_phase
  
endclass



//////////////////////
/////////////////Scoreboard////////////////





class my_sb extends uvm_scoreboard;
    typedef uvm_in_order_class_comparator #(packet) packet_cmp;
  packet_cmp comparator;
  
   uvm_analysis_export #(packet) before_export;
  uvm_analysis_export #(packet) after_export;

  
  
  `uvm_component_utils(my_sb)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_LOW);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_LOW);
    comparator = packet_cmp::type_id::create("comparator", this);
    before_export = new("before_export", this);
    after_export  = new("after_export", this);
 endfunction: build_phase
  
  
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_LOW);
          this.before_export.connect(comparator.before_export);
    this.after_export.connect(comparator.after_export); 


  endfunction: connect_phase
  
    virtual function void report_phase(uvm_phase phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_LOW);
    `uvm_info("Scoreboard_Report",
      $sformatf("Comparator Matches = %0d, Mismatches = %0d", comparator.m_matches, comparator.m_mismatches), UVM_MEDIUM);
  endfunction: report_phase
  
  
endclass
































