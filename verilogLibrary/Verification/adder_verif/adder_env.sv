
//-------------------------------------------------------------------------
//						adder_env - www.verificationguide.com
//-------------------------------------------------------------------------

class adder_env extends uvm_env;

   //---------------------------------------
   // agent and scoreboard instance
   //---------------------------------------
   adder_agent      adder_agnt;
   adder_scoreboard adder_scb;

   `uvm_component_utils(adder_env)

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
      adder_scb  = adder_scoreboard::type_id::create("adder_scb", this);
   endfunction : build_phase

   //---------------------------------------
   // connect_phase - connecting monitor and scoreboard port
   //---------------------------------------
   function void connect_phase(uvm_phase phase);
      adder_agnt.monitor.item_collected_port.connect(adder_scb.item_collected_export);
   endfunction : connect_phase

endclass : adder_env
