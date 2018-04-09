import uvm_pkg::*;
`include "uvm_macros.svh"




program testTop;


  initial
    
    begin
      
      `uvm_info("TRACE", $sformatf("Starting Test"), UVM_NONE);
      run_test("my_test");
      
    end
endprogram // test


typedef class my_env;

class my_test extends uvm_test;
  

  
  `uvm_component_utils(my_test)
  
   my_env env;

   function new(string name, uvm_component parent);

      super.new(name, parent);

     `uvm_info("TRACE", $sformatf("%m"), UVM_NONE);

   endfunction: new
   

   virtual function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      `uvm_info("TRACE", $sformatf("%m"), UVM_NONE);
      env = my_env::type_id::create("env",this);
   endfunction // build_phase



   virtual task run_phase(uvm_phase phase);

     `uvm_info("TRACE", $sformatf("%m"), UVM_NONE);
      #10
	$display("%t In run phase now\n");
      

   endtask // run_phase
   
   

endclass // test


class my_env extends uvm_env;


`uvm_component_utils(my_env)

   
   function new(string name, uvm_component parent);


      super.new(name, parent);
      
      
      `uvm_info("TRACE", $sformatf("%m"), UVM_NONE);

      
   endfunction: new  
   
endclass // my_env
   

