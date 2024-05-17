class my_transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)
   function new(string name= "");
      super.new(name);
   endfunction // new
endclass // transaction


class my_sequence extends uvm_sequence;
   `uvm_object_utils(my_sequence)

   function new(string name= "");
      super.new(name);
   endfunction // new

   task body();
      super.body();
   endtask

endclass // my_sequence



class my_driver extends uvm_driver#(my_transaction, my_transaction);
   `uvm_component_utils(driver)
   virtual dut_interface vif;

   function new(string name = "", uvm_component parent)
     super.new(parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      assert(uvm_config_db#(virtual dut_interface)::get(this, "", "dut_intf", vif))
        else `uvm_fatal(get_name(), $sformatf("Unable to retrieve interface"))
   endfunction // build_phase

   task run_phase(uvm_phase phase);

   endtask // run_phase


endclass // driver


class my_monitor extends uvm_monitor#(my_transaction);
   `uvm_component_utils(my_monitor)

   virtual dut_interface vif;

   function new(string name = "", uvm_component parent)
     super.new(parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      assert(uvm_config_db#(virtual dut_interface)::get(this, "", "dut_intf", vif))
        else `uvm_fatal(get_name(), $sformatf("Unable to retrieve interface"))
   endfunction // build_phase

   task run_phase(uvm_phase phase);

   endtask // run_phase

endclass // driver


class my_agent extends uvm_agent;
   `uvm_component_utils(my_agent)

   my_driver drv;
   my_monitor mon;
   uvm_sequencer#(my_transaction) sqr;

   function new(string name = "", uvm_component parent)
     super.new(parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      sqr = uvm_sequencer#(my_transaction)::type_id::create("sqr", this);
      mon = my_monitor#(my_transaction)::type_id::create("mon", this);
   endfunction // build_phase


   function void connect_phase(uvm_phase phase);
      agt.sequence_item_port(sqr.sequence_item_export);
   endfunction // connect_phase


endclass // driver

`uvm_declare(_input_analysis_port)
`uvm_declare(_output_analysis_port)

class my_scoreboard extends  uvm_scoreboard;

 `uvm_component_utils(my_scoreboard)

   uvm_analysis_import

   function new(string name = "", uvm_component parent)
     super.new(parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction // build_phase

endclass // my_scoreboard


class my_env extends uvm_env;
   `uvm_component_utils(my_env)

   my_agent agt;
   my_scoreboard scb;

   function new(string name = "", uvm_component parent)
     super.new(parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      agt = my_agent::type_id::create("agt", this);
      scb = my_scoreboard::type_id::create("scb", this);
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);

   endfunction // connect_phase

   
   task run_phase(uvm_phase phase);

   endtask // run_phase

endclass // driver


class my_test extends uvm_test;
   `uvm_component_utils(my_test)

   function new(string name = "", uvm_component parent)
     super.new(parent);
   endfunction // new

   function void build_phase(uvm_phase phase);

   endfunction // build_phase

   task run_phase(uvm_phase phase);

   endtask // run_phase

endclass // driver
