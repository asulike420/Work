


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





class iMonitor extends uvm_monitor;


   uvm_analysis_port #(instruction) analysis_port;

   `uvm_component_utils_begin(iMonitor)

      function new(string name, uvm_component parent);
	 super.new(name, parent);
	 `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      endfunction: new



      virtual function void build_phase(uvm_phase phase); 
         analysis_port = new("analysis_port", this);
	 
      endfunction: build_phase



      virtual task run_phase(uvm_phase phase);
	 $display("Writing data to ");
	 tr = instruction:type_id::create("tr", this);
	 
	 analysis_port.write(tr);
      endtask: run_phase


   endclass: iMonitor


class my_test extends uvm_test;
  `uvm_component_utils(my_test)
   
//   instruction_driver drv;
  
   iMonitor mon;



   
   
// Constructor 
function new (string name, uvm_component parent); 
super.new(name, parent); 
endfunction // new


   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
 
       mon = instruction_driver::type_id::create("mon",this);
      
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
