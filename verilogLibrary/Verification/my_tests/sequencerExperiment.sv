
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

//`uvm_sequence_utils(operation_addition, instruction_sequencer) 
  `uvm_object_utils(operation_addition)
virtual task body(); 
//req = instruction::type_id::create("req"); 
//wait_for_grant(); 
//assert(req.randomize() with { 
//inst == instruction::PUSH_A; 
//}); 
//send_request(req);
//      $display(" Waiting for item done");
//   wait_for_item_done();
//   
//   $display("Done waiting for item");
//   
////get_response(res); This is optional. Not using in this example. 
//
//req = instruction::type_id::create("req"); 
//wait_for_grant(); 
//req.inst = instruction::PUSH_B; 
//send_request(req); 
//wait_for_item_done(); 
////get_response(res); 
//
//req = instruction::type_id::create("req"); 
//wait_for_grant(); 
//req.inst = instruction::ADD; 
//send_request(req); 
//wait_for_item_done(); 
////get_response(res); 
//
//req = instruction::type_id::create("req"); 
//wait_for_grant(); 
//req.inst = instruction::POP_C; 
//send_request(req); 
//wait_for_item_done(); 
////get_response(res);
   repeat(3) begin
      $display("%t Sequence1: Generating instruction from sequence",$time);
      
   `uvm_do(req);
      wait_for_item_done();
      
   end
   $display("%t Sequence2: sequence done",$time);
   
endtask 

endclass // operation_addition



   
class instruction_driver extends uvm_driver #(instruction); 

// Provide implementations of virtual methods such as get_type_name and create 
`uvm_component_utils(instruction_driver) 

// Constructor 
function new (string name, uvm_component parent); 
super.new(name, parent); 
endfunction 

//task run ();
   virtual task run_phase(uvm_phase phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      
      forever begin
	 $display("%t : Driver 1 : Starting send req from driver", $time);   
	 seq_item_port.get_next_item(req); 
	 $display("%0d: Driver2: Got instruction from sequencer ",$time,req.inst.name()); 
	 #10; 
	 // rsp.set_id_info(req); These two steps are required only if 
	 // seq_item_port.put(esp); responce needs to be sent back to sequence

	 seq_item_port.item_done();
	 $display("%t : Driver 3: Item done successfully", $time);  
      end 
   endtask 

endclass // instruction_driver




class my_test extends uvm_test;
  `uvm_component_utils(my_test)
   
   instruction_driver drv;
  uvm_sequencer#(instruction) sequencer;
   
// Constructor 
function new (string name, uvm_component parent); 
super.new(name, parent); 
endfunction // new

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
     sequencer = uvm_sequencer#(instruction)::type_id::create("sequencer",this);
      drv = instruction_driver::type_id::create("drv", this);
      uvm_config_db #(uvm_object_wrapper)::set(this, "sequencer.main_phase", "default_sequence", operation_addition::get_type());
      sequencer.print();
      
   endfunction: build_phase   

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
      
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    drv.seq_item_port.connect(sequencer.seq_item_export);
  endfunction: connect_phase

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
   reg  clk;
   
   initial begin 
      run_test("my_test");
      clk = 0;
      
      #200 $finish();
      
      end

   always #5 clk = ~clk;
   

   
endmodule // top

