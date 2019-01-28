`ifndef RW_ENV__SV
`define RW_ENV__SV


class rw_env extends uvm_env;

   rw_agent agent;
   virtual_sequencer v_sqr;

  `uvm_component_utils(rw_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    agent = rw_agent::type_id::create("agent", this);
    v_sqr = virtual_sequencer::type_id::create("v_sqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
     v_sqr.r_sqr = this.agent.r_sqr;
     v_sqr.w_sqr = this.agent.w_sqr;
  endfunction

endclass

`endif
