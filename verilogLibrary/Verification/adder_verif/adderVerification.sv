



//-------------------------------------------------------------------------
//						adder_monitor - www.verificationguide.com
//-------------------------------------------------------------------------

class adder_monitor extends uvm_monitor;

   //---------------------------------------
   // Virtual Interface
   //---------------------------------------
   virtual adder_if vif;

   //---------------------------------------
   // analysis port, to send the transaction to scoreboard
   //---------------------------------------
   uvm_analysis_port #(adder_seq_item) item_collected_port;

   //---------------------------------------
   // The following property holds the transaction information currently
   // begin captured (by the collect_address_phase and data_phase methods).
   //---------------------------------------
   adder_seq_item trans_collected;

   `uvm_component_utils(adder_monitor)

   //---------------------------------------
   // new - constructor
   //---------------------------------------
   function new (string name, uvm_component parent);
      super.new(name, parent);
      trans_collected = new();
      item_collected_port = new("item_collected_port", this);
   endfunction : new

   //---------------------------------------
   // build_phase - getting the interface handle
   //---------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
   endfunction: build_phase

   //---------------------------------------
   // run_phase - convert the signal level activity to transaction level.
   // i.e, sample the values on interface signal ans assigns to transaction class fields
   //---------------------------------------
   virtual task run_phase(uvm_phase phase);
      forever begin
         @(posedge vif.MONITOR.clk);
         trans_collected.rdata = vif.monitor_cb.sum;
	     item_collected_port.write(trans_collected);
      end
   endtask : run_phase

endclass : adder_monitor


//-------------------------------------------------------------------------
//						mem_scoreboard - www.verificationguide.com
//-------------------------------------------------------------------------

// class mem_scoreboard extends uvm_scoreboard;
//
//   //---------------------------------------
//   // declaring pkt_qu to store the pkt's recived from monitor
//   //---------------------------------------
//   mem_seq_item pkt_qu[$];
//
// //---------------------------------------
//   //port to recive packets from monitor
//   //---------------------------------------
//   uvm_analysis_imp#(mem_seq_item, mem_scoreboard) item_collected_export;
//   `uvm_component_utils(mem_scoreboard)
//
//   //---------------------------------------
//   // new - constructor
//   //---------------------------------------
//   function new (string name, uvm_component parent);
//     super.new(name, parent);
//   endfunction : new
//
//   //---------------------------------------
//   // build_phase - create port and initialize local memory
//   //---------------------------------------
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//       item_collected_export = new("item_collected_export", this);
//       foreach(sc_mem[i]) sc_mem[i] = 8'hFF;
//   endfunction: build_phase
//
//   //---------------------------------------
//   // write task - recives the pkt from monitor and pushes into queue
//   //---------------------------------------
//   virtual function void write(mem_seq_item pkt);
//     //pkt.print();
//     pkt_qu.push_back(pkt);
//   endfunction : write
//
//   //---------------------------------------
//   // run_phase - compare's the read data with the expected data(stored in local memory)
//   // local memory will be updated on the write operation.
//   //---------------------------------------
//   virtual task run_phase(uvm_phase phase);
//     mem_seq_item mem_pkt;
//
//     forever begin
//       wait(pkt_qu.size() > 0);
//       mem_pkt = pkt_qu.pop_front();
//
//       if(mem_pkt.wr_en) begin
//         sc_mem[mem_pkt.addr] = mem_pkt.wdata;
//         `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
//         `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
//         `uvm_info(get_type_name(),$sformatf("Data: %0h",mem_pkt.wdata),UVM_LOW)
//         `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
//       end
//       else if(mem_pkt.rd_en) begin
//         if(sc_mem[mem_pkt.addr] == mem_pkt.rdata) begin
//           `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[mem_pkt.addr],mem_pkt.rdata),UVM_LOW)
//           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
//         end
//         else begin
//           `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
//           `uvm_info(get_type_name(),$sformatf("Addr: %0h",mem_pkt.addr),UVM_LOW)
//           `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_mem[mem_pkt.addr],mem_pkt.rdata),UVM_LOW)
//           `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
//         end
//       end
//     end
//   endtask : run_phase
// endclass : mem_scoreboard


//-------------------------------------------------------------------------
//						mem_agent - www.verificationguide.com
//-------------------------------------------------------------------------

//`include "mem_seq_item.sv"
//`include "mem_sequencer.sv"
//`include "mem_sequence.sv"
//`include "mem_driver.sv"
//`include "mem_monitor.sv"

class adder_agent extends uvm_agent;

   //---------------------------------------
   // component instances
   //---------------------------------------
   adder_driver    driver;
   adder_sequencer sequencer;
   adder_monitor   monitor;

   `uvm_component_utils(adder_agent)

   //---------------------------------------
   // constructor
   //---------------------------------------
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   //---------------------------------------
   // build_phase
   //---------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      monitor = adder_monitor::type_id::create("monitor", this);

      //creating driver and sequencer only for ACTIVE agent
      if(get_is_active() == UVM_ACTIVE) begin
         driver    = adder_driver::type_id::create("driver", this);
         sequencer = adder_sequencer::type_id::create("sequencer", this);
      end
   endfunction : build_phase

   //---------------------------------------
   // connect_phase - connecting the driver and sequencer port
   //---------------------------------------
   function void connect_phase(uvm_phase phase);
      if(get_is_active() == UVM_ACTIVE) begin
         driver.seq_item_port.connect(sequencer.seq_item_export);
      end
   endfunction : connect_phase

endclass : adder_agent


//-------------------------------------------------------------------------
//						adder_env - www.verificationguide.com
//-------------------------------------------------------------------------

class adder_model_env extends uvm_env;

   //---------------------------------------
   // agent and scoreboard instance
   //---------------------------------------
   adder_agent      adder_agnt;
   // adder_scoreboard adder_scb;

   `uvm_component_utils(adder_model_env)

   //---------------------------------------
   // constructor
   //---------------------------------------
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   //---------------------------------------
   // build_phase - crate the components
   //---------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      adder_agnt = adder_agent::type_id::create("adder_agnt", this);
      //adder_scb  = adder_scoreboard::type_id::create("adder_scb", this);
   endfunction : build_phase

   //---------------------------------------
   // connect_phase - connecting monitor and scoreboard port
   //---------------------------------------
   function void connect_phase(uvm_phase phase);
      //adder_agnt.monitor.item_collected_port.connect(adder_scb.item_collected_export);
   endfunction : connect_phase

endclass : adder_model_env

//-------------------------------------------------------------------------
//						adder_env - www.verificationguide.com
//-------------------------------------------------------------------------

class adder_model_env extends uvm_env;

   //---------------------------------------
   // agent and scoreboard instance
   //---------------------------------------
   adder_agent      adder_agnt;
   // adder_scoreboard adder_scb;

   `uvm_component_utils(adder_model_env)

   //---------------------------------------
   // constructor
   //---------------------------------------
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   //---------------------------------------
   // build_phase - crate the components
   //---------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      adder_agnt = adder_agent::type_id::create("adder_agnt", this);
      //adder_scb  = adder_scoreboard::type_id::create("adder_scb", this);
   endfunction : build_phase

   //---------------------------------------
   // connect_phase - connecting monitor and scoreboard port
   //---------------------------------------
   function void connect_phase(uvm_phase phase);
      //adder_agnt.monitor.item_collected_port.connect(adder_scb.item_collected_export);
   endfunction : connect_phase

endclass : adder_model_env

//-------------------------------------------------------------------------
//						adder_test - www.verificationguide.com
//-------------------------------------------------------------------------

//`include "adder_env.sv"
class adder_model_base_test extends uvm_test;

   `uvm_component_utils(adder_model_base_test)

   //---------------------------------------
   // env instance
   //---------------------------------------
   adder_model_env env;

   //---------------------------------------
   // constructor
   //---------------------------------------
   function new(string name = "adder_model_base_test",uvm_component parent=null);
      super.new(name,parent);
   endfunction : new

   //---------------------------------------
   // build_phase
   //---------------------------------------
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      // Create the env
      env = adder_model_env::type_id::create("env", this);
   endfunction : build_phase

   //---------------------------------------
   // end_of_elobaration phase
   //---------------------------------------
   virtual function void end_of_elaboration();
      //print's the topology
      print();
   endfunction

   //---------------------------------------
   // end_of_elobaration phase
   //---------------------------------------
   function void report_phase(uvm_phase phase);
      uvm_report_server svr;
      super.report_phase(phase);

      svr = uvm_report_server::get_server();
      if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
      else begin
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
         `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
         `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
      end
   endfunction

endclass : adder_model_base_test



module tbench_top;

   //---------------------------------------
   //clock and reset signal declaration
   //---------------------------------------
   bit clk;
   bit reset;

   //---------------------------------------
   //clock generation
   //---------------------------------------
   always #5 clk = ~clk;

   //---------------------------------------
   //reset Generation
   //---------------------------------------
   initial begin
      reset = 1;
      #5 reset =0;
   end

   //---------------------------------------
   //interface instance
   //---------------------------------------
   adder_if intf(clk,reset);

   //---------------------------------------
   //DUT instance
   //---------------------------------------
   adderory DUT (
               .clk(intf.clk),
               .reset(intf.reset),
               .a(intf.a),
               .b(intf.b),
               .sum(intf.sum),
     );

   //---------------------------------------
   //passing the interface handle to lower heirarchy using set method
   //and enabling the wave dump
   //---------------------------------------
   initial begin
      uvm_config_db#(virtual adder_if)::set(uvm_root::get(),"*","vif",intf);
      //enable wave dump
      $dumpfile("dump.vcd");
      $dumpvars;
   end

   //---------------------------------------
   //calling test
   //---------------------------------------
   initial begin
      run_test();
   end

endmodule
