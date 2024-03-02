//------------------------------------------------------
//uvm_resource_db::set(input string scope, input string name,T val, input uvm_object accessor = null)
//   -Create a new resource, write a val to it, and set it into the database using name and scope as the lookup parameters.  The accessor is used for auditting.
//  -Note that set(), can only be used to create a new resource. If resource already exists, the value of the resource cannot be updated using this method. If resource has to be updated, use write().
//
//uvm_resource_db::write_by_name
//
//
//
//
//------------------------------------------------------

`include "uvm_macros.svh"
import uvm_pkg::*;


class comp1 extends uvm_component;


   `uvm_component_utils(comp1)

   function new(string name, uvm_component parent);
      super.new(name, parent);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction // new

   //---------------------------------------
   // run_phase
   //---------------------------------------
   virtual task run_phase(uvm_phase phase);
      int ctrl;

      phase.raise_objection(this);

      `uvm_info(get_type_name(),$sformatf("Before calling uvm_resource_db , get_type_name() ctrl = %d", ctrl), UVM_LOW)

      if(!uvm_resource_db #(int)::read_by_name(get_full_name(), "ctrl_tb_top", ctrl))
        `uvm_fatal(get_type_name(), "read_by_name failed for resource in this scope");

      `uvm_info(get_type_name(),$sformatf("After  calling uvm_resource_db, read_by_name() ctrl = %d", ctrl), UVM_LOW)
      ctrl = 3;

      `uvm_info(get_type_name(),$sformatf("Updating  uvm_resource_db, using set()  ctrl_tb_top = %d", ctrl), UVM_LOW)
     uvm_resource_db #(int)::write_by_name("*", "ctrl_tb_top", ctrl, this);

      phase.drop_objection(this);
   endtask : run_phase


endclass // comp1




class comp2 extends uvm_component;

   `uvm_component_utils(comp2)

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new


   //---------------------------------------
   // run_phase
   //---------------------------------------
   virtual task run_phase(uvm_phase phase);
      int ctrl;
      phase.raise_objection(this);

      `uvm_info(get_type_name(),$sformatf(" Before calling uvm_resource_db , get_type_name() ctrl = %d", ctrl), UVM_LOW)

      #1;

      if(!uvm_resource_db #(int)::read_by_name(get_full_name(), "ctrl_tb_top", ctrl))
        `uvm_fatal(get_type_name(), "read_by_name failed for resource in this scope");


      `uvm_info(get_type_name(),$sformatf(" After  calling uvm_resource_db, read_by_name() ctrl = %d", ctrl), UVM_LOW)

      phase.drop_objection(this);
   endtask : run_phase

endclass // comp2



class test extends uvm_test;

   //---------------------------------------
   // Components Instantiation
   //---------------------------------------
   comp1 comp_a;
   comp2 comp_b;

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
     uvm_resource_db #(int)::set("*", "ctrl_tb_top", 2, this);
   endfunction : build_phase



endclass // test




module tb;

   initial begin
    // uvm_resource_db #(int)::set("*", "ctrl_tb_top", 2, null);
      run_test("test");
   end

endmodule // tb
