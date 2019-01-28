`ifndef TEST_COLLECTION__SV
`define TEST_COLLECTION__SV


class test_base extends uvm_test;
  `uvm_component_utils(test_base)
   
   virtual read_if r_vif;
   virtual write_if w_vif;
  rw_env env;
  // For convenience, access to the command line processor is done for you
  uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    env = rw_env::type_id::create("env", this);

    uvm_resource_db#(virtual read_if)::read_by_type("read_vif", r_vif, this);
    uvm_resource_db#(virtual write_if)::read_by_type("write_vif", w_vif, this);
     
     uvm_config_db#(virtual read_if)::set(this, "env.agent", "r_vif", r_vif);
     uvm_config_db#(virtual write_if)::set(this, "env.agent", "w_vif", w_vif);
    
    
         uvm_config_db #(virtual read_if)::dump();
     uvm_config_db #(virtual write_if)::dump();
     
        
         uvm_resource_db #(virtual read_if)::dump();
     uvm_resource_db #(virtual write_if)::dump();
    
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.agent.r_sqr.main_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.agent.w_sqr.main_phase", "default_sequence", null);
    uvm_config_db #(uvm_object_wrapper)::set(this, "env.v_sqr.main_phase", "default_sequence", virtual_sequence::get_type());
     
  endfunction: build_phase

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

  endfunction: end_of_elaboration_phase

  virtual task main_phase(uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    objection = phase.get_objection();
    objection.set_drain_time(this, 1us);
  endtask: main_phase

  virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "TOPOLOGY")) begin
      uvm_root::get().print_topology();
    end

    if (uvm_report_enabled(UVM_MEDIUM, UVM_INFO, "FACTORY")) begin
      uvm_factory::get().print();
    end
  endfunction: final_phase
endclass: test_base

`endif

