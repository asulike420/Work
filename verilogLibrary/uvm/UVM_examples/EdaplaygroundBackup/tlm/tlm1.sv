// Code your testbench here
// or browse Examples
/*
 uvm_put_port			 uvm_get_port			 uvm_peek_port

 uvm_blocking_put_port		 uvm_blocking_get_port		 uvm_blocking_peek_port

 uvm_nonblocking_put_port	 uvm_nonblocking_get_port	 uvm_nonblocking_peek_port

 uvm_put_imp			 uvm_get_imp			 uvm_peek_imp

 uvm_blocking_put_imp		 uvm_blocking_get_imp		 uvm_blocking_peek_imp

 uvm_nonblocking_put_imp		 uvm_nonblocking_get_imp	 uvm_nonblocking_peek_imp

 uvm_put_export			 uvm_get_export			 uvm_peek_export

 uvm_blocking_put_export		 uvm_blocking_get_export	 uvm_blocking_peek_export

 uvm_nonblocking_put_export	 uvm_nonblocking_get_export	 uvm_nonblocking_peek_export
 */
// Code your testbench here
// or browse Examples

import uvm_pkg::*;
`include "uvm_macros.svh"


class transaction extends uvm_sequence_item;

   rand bit [7:0] data;

   `uvm_object_utils_begin(transaction)
      `uvm_field_int(data, UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name = "");
      super.new(name);
   endfunction // new
endclass // transaction



class producer  extends uvm_component;
   
   `uvm_component_utils(producer)
   
   //Blocking put port
   uvm_blocking_put_port #(transaction) b_put_port;
   uvm_blocking_get_imp #(transaction, producer) b_get_imp;
   

   //   uvm_put_port #(transaction) put_port;
   
   //Blocking get port
   
   //Non blocking put port
   
   //Non blocking get port
   
   function new (string name = "", uvm_component parrent = null);
      super.new(name, parrent);
      b_put_port = new("b_put_port", this);
      b_get_imp = new("b_get_imp", this);
   endfunction
   
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   
   virtual task run_phase(uvm_phase phase);
      transaction trans;
      phase.raise_objection(this);	
      trans = transaction::type_id::create("trans");
      assert(trans.randomize());
      `uvm_info("Blocking Put Port", "Starting.....", UVM_LOW)
      b_put_port.put(trans);
      `uvm_info("Blocking Put Port", "Completed.....", UVM_LOW)
      phase.drop_objection(this);
   endtask 

   task get(output transaction trans);
      `uvm_info("Blocking Get Imp", "Started.....", UVM_LOW)
      trans = transaction::type_id::create("transaction", this);
      assert(trans.randomize());
      trans.print();
      #5;
      `uvm_info("Blocking Get Imp", "Ended.....", UVM_LOW)
   endtask // get
   
   
   
endclass



class consumer  extends uvm_component;
   
   `uvm_component_utils(consumer)
   
   //Blocking put port
   uvm_blocking_put_imp #(transaction, consumer) b_put_imp;
   uvm_blocking_put_port #(transaction) b_get_port;
   
     //   uvm_put_port #(transaction) put_port;
      
     //Blocking get port
      
     //Non blocking put port
      
     //Non blocking get port
      
     function new (string name = "", uvm_component parrent = null);
	super.new(name, parrent);
	b_put_imp = new("b_put_imp", this);
     endfunction
   
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   
   task put(transaction trans);
      `uvm_info("Blocking Put Import", "Received.....", UVM_LOW)
      #5;
      trans.print();
   endtask // put


   virtual task run_phase(uvm_phase phase);
      transaction trans;
      phase.raise_objection(this);	
      `uvm_info("Blocking get Port", "Starting.....", UVM_LOW)
      b_get_port.get(trans);
      trans.print();
      `uvm_info("Blocking get Port", "Completed.....", UVM_LOW)
      phase.drop_objection(this);
   endtask 
   
   
endclass // consumer



class test extends uvm_test;

   producer prod;
   consumer con;
   
   `uvm_component_utils(test)

   function new (string name, uvm_component parrent = null);
      super.new(name, parrent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      prod = producer::type_id::create("prod", this);
      con  = consumer::type_id::create("con", this);
   endfunction

   
   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      prod.b_put_port.connect(con.b_put_imp);
      con.b_get_port.connect(prod.b_get_imp);
   endfunction

   
endclass // test


module top;
   
   initial
     run_test("test");
   
endmodule
