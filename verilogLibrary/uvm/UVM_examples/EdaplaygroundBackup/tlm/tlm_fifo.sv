`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;

   rand bit[15:0]    addr;
   rand bit [15:0]   data;

   `uvm_object_utils_begin(transaction)
      `uvm_field_int(addr, UVM_ALL_ON)
      `uvm_field_int(data, UVM_ALL_ON)
   `uvm_object_utils_end

   function new(string name="transaction");
      super.new(name);
      `uvm_info("Trace", $sformatf("%m"), UVM_HIGH);
   endfunction

endclass // transaction




class comp1 extends uvm_component;

   uvm_blocking_put_port#(transaction) trans_out;

   `uvm_component_utils(comp1)

   function new(string name, uvm_component parent);
      super.new(name, parent);
      trans_out = new("trans_out", this);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction // new

   //---------------------------------------
   // run_phase
   //---------------------------------------
   virtual task run_phase(uvm_phase phase);
      transaction 	trans;
      phase.raise_objection(this);

      trans = transaction::type_id::create("trans", this);
      void'(trans.randomize());
      `uvm_info(get_type_name(),$sformatf(" tranaction randomized"),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf(" Printing trans, \n %s",
                                          trans.sprint()),UVM_LOW)

      //Step-3. Calling put method to push transaction to TLM FIFO
      `uvm_info(get_type_name(),$sformatf(" Before calling port put method"),UVM_LOW)
      trans_out.put(trans);
      `uvm_info(get_type_name(),$sformatf(" After  calling port put method"),UVM_LOW)

      phase.drop_objection(this);
   endtask : run_phase


endclass // comp1




class comp2 extends uvm_component;

   uvm_blocking_get_port#(transaction) trans_in;
   `uvm_component_utils(comp2)

   function new(string name, uvm_component parent);
      super.new(name, parent);
      trans_in = new("trans_in", this);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction // new


   //---------------------------------------
   // run_phase
   //---------------------------------------
   virtual task run_phase(uvm_phase phase);
      transaction trans;
      phase.raise_objection(this);

      `uvm_info(get_type_name(),$sformatf(" Before calling port get method"),UVM_LOW)
      trans_in.get(trans);  //Step-3. Get the transaction from TLM FIFO
      `uvm_info(get_type_name(),$sformatf(" After  calling port get method"),UVM_LOW)
      `uvm_info(get_type_name(),$sformatf(" Printing trans, \n %s",
                                          trans.sprint()),UVM_LOW)

      phase.drop_objection(this);
   endtask : run_phase

endclass // comp2



class test extends uvm_test;

   //---------------------------------------
   // Components Instantiation
   //---------------------------------------
   comp1 comp_a;
   comp2 comp_b;

   //Step-1. Declaring the TLM FIFO
   uvm_tlm_fifo #(transaction) fifo_ab;

   `uvm_component_utils(test)

   //---------------------------------------
   // Constructor
   //---------------------------------------
   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   //---------------------------------------
   // build_phase - Create the components
   //---------------------------------------
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      comp_a = comp1::type_id::create("comp_a", this);
      comp_b = comp2::type_id::create("comp_b", this);

      //Step-2. Creating the FIFO
      fifo_ab = new("fifo_ab", this);
   endfunction : build_phase


   //---------------------------------------
   // Connect_phase
   //---------------------------------------
   function void connect_phase(uvm_phase phase);

      //Step-3. Connecting FIFO put_export with producer port
      comp_a.trans_out.connect(fifo_ab.put_export);
      //Step-4. Connecting FIFO get_export with consumer port
      comp_b.trans_in.connect(fifo_ab.get_export);
   endfunction : connect_phase


endclass // test




module tb;

   initial begin
      run_test("test");
   end

endmodule // tb
