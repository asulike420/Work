
import uvm_pkg::*;
`include "uvm_macros.svh"

//typedef class instruction_sequencer; //Forward referencing

class instruction extends uvm_sequence_item; 
typedef enum {PUSH_A,PUSH_B,ADD,SUB,MUL,DIV,POP_C} inst_t; 
rand inst_t inst; 

`uvm_object_utils_begin(instruction) 
`uvm_field_enum(inst_t,inst, UVM_ALL_ON) 
`uvm_object_utils_end 

function new (string name = "instruction"); 
super.new(name); //Need to understand why this super new needs to be called with name
endfunction 

endclass // instruction


class operation_addition extends uvm_sequence #(instruction); 

   //instruction req; 

   function new(string name="operation_addition"); 
      super.new(name);
      set_automatic_phase_objection(1);
      
   endfunction 


   `uvm_object_utils(operation_addition)
   virtual   task body(); 
      repeat(3) begin
	 $display("%t Sequence1: Generating instruction from sequence",$time);
	// req.print();
	 
	 //`uvm_do(req);
 //Need to check how it would respond without driver.
//	 wait_for_item_done();
	 
      end
      $display("%t Sequence2: sequence done",$time);
      
   endtask 

endclass // operation_addition




class my_test extends uvm_test;
  `uvm_component_utils(my_test)
   
  uvm_sequencer#(instruction) sequencer;
   
// Constructor 
function new (string name, uvm_component parent); 
super.new(name, parent); 
endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
     sequencer = uvm_sequencer#(instruction)::type_id::create("sequencer",this);
      uvm_config_db #(uvm_object_wrapper)::set(this, "sequencer.main_phase", "default_sequence", operation_addition::get_type());
      sequencer.print();
      
   endfunction: build_phase   



task run_phase(uvm_phase phase);
     phase.raise_objection(this);
     uvm_top.print_topology();
     #150;
     phase.drop_objection(this);
  endtask

   
function void report(); 
uvm_report_info(get_full_name(),"Report", UVM_LOW); 
endfunction 


   
   
endclass // test



module top;

   initial run_test("my_test");
endmodule // top
