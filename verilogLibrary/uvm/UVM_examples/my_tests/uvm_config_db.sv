// Code your testbench here
// or browse Examples
`include "uvm_macros.svh"
import uvm_pkg::*;

class env extends uvm_env;

`uvm_component_utils(env)

  string tname;

  function new(string name="env", uvm_component parrent = null);
  super.new(name, parrent);
  `uvm_info(get_type_name(), "Created Env", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  uvm_config_db#(string)::get(this,"", "test_name", tname);
	`uvm_info(get_type_name(), $psprintf("tname = %s", tname), UVM_LOW)
endfunction

endclass


class test extends uvm_test;
`uvm_component_utils(test)

string tname = "test";  
env tb_env;
  
function new(string name="test", uvm_component parrent);
  super.new(name, parrent);
  `uvm_info(get_type_name(), "Created my test", UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(), $psprintf("tname = %s", tname), UVM_LOW)
  tb_env = env::type_id::create("tb_env", this);
  uvm_config_db#(string)::set(this,"tb_env", "test_name", tname);
  
endfunction
  


endclass


  module test();
    
    initial begin
      run_test("test");
      #10ns;
      $display($time);
    end
    
  endmodule
