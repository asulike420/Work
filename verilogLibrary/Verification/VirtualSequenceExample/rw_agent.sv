`ifndef RW_AGENT__SV
`define RW_AGENT__SV

//typedef uvm_sequencer #(rw_seq_item) _sequencer;
//typedef uvm_sequencer packet_sequencer;

class rw_agent extends uvm_agent;
  uvm_sequencer#(rw_seq_item)            r_sqr, w_sqr;
   rw_driver                      r_drv, w_drv;
   virtual write_if           w_vif;
   virtual read_if r_vif;
   
  `uvm_component_utils(rw_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    if (is_active == UVM_ACTIVE) begin
       r_sqr = uvm_sequencer#(rw_seq_item)::type_id::create("r_sqr", this);
       r_drv = rw_driver::type_id::create("r_drv", this);
       w_sqr = uvm_sequencer#(rw_seq_item)::type_id::create("w_sqr", this);
       w_drv = rw_driver::type_id::create("w_drv", this);
    end

          uvm_config_db#(virtual read_if)::get(this, "", "r_vif", r_vif);
      uvm_config_db#(virtual write_if)::get(this, "", "w_vif", w_vif);

    uvm_config_db#(virtual read_if)::set(this, "*", "r_vif", r_vif);
    uvm_config_db#(virtual write_if)::set(this, "*", "w_vif", w_vif);
     
    uvm_config_db#(int)::set(this, "r_drv", "direction", 1);
    uvm_config_db#(int)::set(this, "w_drv", "direction", 0);
    
         
  endfunction: build_phase

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    if (is_active == UVM_ACTIVE) begin
       r_drv.seq_item_port.connect(r_sqr.seq_item_export);
      w_drv.seq_item_port.connect(w_sqr.seq_item_export);
    end
  endfunction: connect_phase
endclass: rw_agent

`endif
