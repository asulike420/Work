`include "uvm_macros.svh"
  import uvm_pkg::*;


//module defination
module add_1(add_if addif);

 //  input a, b;
 //  output cout, sum;
  initial $monitor("addif.a=%d, addif.b=%d",addif.a , addif.b);

   assign {addif.cout,addif.sum} = addif.a + addif.b;
   

endmodule // add_1

   
//interface defination
interface add_if();
   logic a, b, cout, sum;
    
endinterface // add_if
   

//top

module top();

   //import uvm pkg for run_test method
   import uvm_pkg::*;
   
   //instatiate interface;
   add_if dut_if();
   //instantiate DUT
   add_1 DUT (dut_if);

   initial
     begin
	// Place the interface into the UVM configuration database
	uvm_config_db#(virtual add_if)::set(null, "*", "dut_vif", dut_if);
	$display("calling run_test\n");
	//#10 Not allowed before calling run_test.
	  run_test("my_test");
	
     end

endmodule // top

typedef class my_env;
   typedef class my_agent;
   typedef class my_driver;
   
typedef my_transaction;
     typedef class my_sequence;

//env////////////////////
class my_test extends uvm_test;

   //Register test to factory
   `uvm_component_utils(my_test)
   //Instantiate env
   my_env env;
   
   
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction // new
   
   //Build phase
  function void build_phase(uvm_phase phase);
     
      env = my_env::type_id::create("env",this);
   endfunction // build_phase
   
   //run_phase
   task run_phase (uvm_phase phase);
      phase.raise_objection(this);
      #50
	`uvm_warning("","Hello Abhay")
      // We drop objection to allow the test to complete
      phase.drop_objection(this);
      
   endtask // run_phase
   

endclass
////////////////////////////////////////////////////

class my_env extends uvm_env;

   `uvm_component_utils(my_env);
   my_agent agent;

       function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      agent = my_agent::type_id::create("agent", this);
    endfunction
   
endclass // my_env




//agent
class my_agent extends uvm_agent;

   `uvm_component_utils(my_agent)
   
   my_driver driver;
   uvm_sequencer#(my_transaction) sequencer;
   

   function new(string name , uvm_component parrent);
      super.new(name,parrent);
   endfunction // new

   //Build phase
   function void build_phase(uvm_phase phase);
      //Configure sequencer
      sequencer = uvm_sequencer#(my_transaction)::type_id::create("sequencer",this);
      
      //Driver
      driver = my_driver::type_id::create("driver",this);
      
   endfunction // build_phase

   function void connect_phase (uvm_phase phase);

      driver.seq_item_port.connect(sequencer.seq_item_export);
            
   endfunction // connect_phase

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      begin
	 my_sequence seq;
	 seq = my_sequence::type_id::create("seq");
	 seq.start(sequencer);
	 
      end
      phase.drop_objection(this);
      
   endtask // run_phase
   
      
   
endclass // my_agent



//my_transaction

class my_transaction extends uvm_sequence_item;
   `uvm_object_utils(my_transaction)

   rand bit a, b;

   function new (string name = "");
      super.new(name);
   endfunction // new

endclass // my_transaction


//sequence
class my_sequence extends uvm_sequence#(my_transaction);

   `uvm_object_utils(my_sequence)
   function new (string name = "");
      super.new(name);
   endfunction // new

   task body;
      repeat(8) begin
	 req = my_transaction::type_id::create("req");
	 start_item(req);
	 if (!req.randomize()) begin
            `uvm_error("MY_SEQUENCE", "Randomize failed.");
	 end
	 finish_item(req);
      end
   endtask //
   
   

endclass // my_sequence



//driver
class my_driver extends uvm_driver#(my_transaction);

   `uvm_component_utils(my_driver)
   virtual add_if dut_vif;
   
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  //Try removing build phase , it should not fail if the interface is registered with the DB.
     function void build_phase(uvm_phase phase);
    // Get interface reference from config database
       if(!uvm_config_db#(virtual add_if)::get(this, "", "dut_vif", dut_vif)) begin
      `uvm_error("", "uvm_config_db::get failed")
    end
  endfunction 
   
   task run_phase(uvm_phase phase);
      #1;
      forever begin
	 seq_item_port.get_next_item(req);
	 dut_vif.a = req.a;
	 dut_vif.b = req.b;
	 #1;
	 seq_item_port.item_done();
	 
      end
   endtask // run_phase
   


   
endclass // my_driver

     



