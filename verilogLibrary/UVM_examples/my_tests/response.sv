

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef class instruction_sequencer; //Forward referencing

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


   
/////////////
///UVM sequence
/////////


class operation_addition extends uvm_sequence #(instruction); 

instruction req; 

function new(string name="operation_addition"); 
super.new(name); 
endfunction 

`uvm_sequence_utils(operation_addition, instruction_sequencer) 

virtual task body(); 
req = instruction::type_id::create("req"); 
wait_for_grant(); 
assert(req.randomize() with { 
inst == instruction::PUSH_A; 
}); 
send_request(req); 
wait_for_item_done(); 
//get_response(res); This is optional. Not using in this example. 

req = instruction::type_id::create("req"); 
wait_for_grant(); 
req.inst = instruction::PUSH_B; 
send_request(req); 
wait_for_item_done(); 
//get_response(res); 

req = instruction::type_id::create("req"); 
wait_for_grant(); 
req.inst = instruction::ADD; 
send_request(req); 
wait_for_item_done(); 
//get_response(res); 

req = instruction::type_id::create("req"); 
wait_for_grant(); 
req.inst = instruction::POP_C; 
send_request(req); 
wait_for_item_done(); 
//get_response(res); 
endtask 

endclass // operation_addition



class instruction_sequencer extends uvm_sequencer #(instruction); 

function new (string name, uvm_component parent); 
super.new(name, parent); 
`uvm_update_sequence_lib_and_item(instruction) 
endfunction 

`uvm_sequencer_utils(instruction_sequencer) 

endclass // instruction_sequencer



class instruction_driver extends uvm_driver #(instruction); 

// Provide implementations of virtual methods such as get_type_name and create 
`uvm_component_utils(instruction_driver) 

// Constructor 
function new (string name, uvm_component parent); 
super.new(name, parent); 
endfunction 

task run (); 
forever begin 
seq_item_port.get_next_item(req); 
$display("%0d: Driving Instruction %s",$time,req.inst.name()); 
#10; 
// rsp.set_id_info(req); These two steps are required only if 
// seq_item_port.put(esp); responce needs to be sent back to sequence 
seq_item_port.item_done(); 
end 
endtask 

endclass // instruction_driver





module test; 

instruction_sequencer sequencer; 
instruction_driver driver; 

initial begin 
set_config_string("sequencer", "default_sequence", "operation_addition"); 
sequencer = new("sequencer", null); 
sequencer.build(); 
driver = new("driver", null); 
driver.build(); 

driver.seq_item_port.connect(sequencer.seq_item_export); 
sequencer.print(); 
fork 
begin 
run_test(); 
sequencer.start_default_sequence(); 
end 
#2000 global_stop_request(); 
join 
end 

endmodule
