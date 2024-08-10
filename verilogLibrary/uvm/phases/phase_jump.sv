//https://www.edaplayground.com/x/6LJz
`include "uvm_macros.svh"

package pkg;
  import uvm_pkg::*;
  

  class env extends uvm_env;
    `uvm_component_utils(env)
    
    int m_delay;
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      if (!uvm_config_db#(int)::get(this, "", "delay", m_delay))
        `uvm_fatal("", "Delay missing from config db")
    endfunction
    
    task reset_phase(uvm_phase phase);
      `uvm_info("", "reset_phase called", UVM_MEDIUM)
      phase.raise_objection(this);
      #(m_delay);
      phase.drop_objection(this);
      `uvm_info("", "reset_phase returning", UVM_HIGH)
    endtask
    
    task configure_phase(uvm_phase phase);
      `uvm_info("", "configure_phase called", UVM_MEDIUM)
      phase.raise_objection(this);
      #(m_delay);
      phase.drop_objection(this);
      `uvm_info("", "configure_phase returning", UVM_HIGH)
    endtask
    
    bit m_busy = 0;
    
    task main_phase(uvm_phase phase);
      `uvm_info("", "main_phase called", UVM_MEDIUM)
      phase.raise_objection(this);
      m_busy = 1;
      #(m_delay);
      m_busy = 0;
      phase.drop_objection(this);
      `uvm_info("", "main_phase returning", UVM_HIGH)
    endtask
    
    task shutdown_phase(uvm_phase phase);
      `uvm_info("", "shutdown_phase called", UVM_MEDIUM)
      phase.raise_objection(this);
      #(m_delay);
      phase.drop_objection(this);
      `uvm_info("", "shutdown_phase returning", UVM_HIGH)
    endtask


// 4) phase_ended can be used to tidy up after a phase jump
//    On a phase jump, all child processes of the phase method are killed
//      and hence any sequences started in that phase are killed automatically
//    All objections for that phase are dropped automatically (objection count is reset to zero)
  
    function void phase_ended(uvm_phase phase);
      if (phase.get_objection() != null)
        assert( phase.get_objection_count() == 0);
      if (m_busy)
        `uvm_info("", {phase.get_full_name(), " phase_ended called when busy"}, UVM_MEDIUM)
      m_busy = 0;     
    endfunction

  endclass

  
  class test extends uvm_test;
    `uvm_component_utils(test)
    
    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    env m_env1;
    env m_env2;

    uvm_domain domain1;
    uvm_domain domain2;
    
    function void build_phase(uvm_phase phase);
      uvm_config_db#(int)::set(this, "m_env1", "delay", 10);
      uvm_config_db#(int)::set(this, "m_env2", "delay", 100);
      
      m_env1 = env::type_id::create("m_env1", this);
      m_env2 = env::type_id::create("m_env2", this);
      
      domain1 = new("domain1");
      m_env1.set_domain(domain1);
      
      domain2 = new("domain2");
      m_env2.set_domain(domain2);

// 3) If another domain is synced to a domain that jumps backward, the synced domain will not jump
//    but will wait for the jumped domain to catch up.
//    If a domain jumps forward, the synced domain will not jump but will be allowed to proceed 
    
      domain1.sync(domain2);
    endfunction
    
    function void start_of_simulation_phase(uvm_phase phase);
      //this.set_report_verbosity_level_hier(UVM_HIGH);
    endfunction
    
    task run_phase(uvm_phase phase);

    
// 1) Can jump a domain forward or backward in the phase sequence
//    Backward jumps should be restricted to run-time phases

      #250; // Middle of main phase
      domain2.jump(uvm_reset_phase::get());

//    Abandons the current phase for all the components in the given domain

      
// 2) Forward jumps should be restricted to post-run-time common phases

      #250; // Middle of main phase
      domain2.jump(uvm_extract_phase::get());
      
// Do not attempt to jump over run-time phases or jump into parallel phases

    endtask
    
  endclass
endpackage


module top;

  import uvm_pkg::*;
  import pkg::*;

  initial
    run_test("test");
  
endmodule
