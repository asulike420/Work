`ifndef RW_DRIVER__SV
 `define RW_DRIVER__SV

class rw_driver extends uvm_driver #(rw_seq_item);
   //virtual rw_io vif;          // DUT virtual interface
   virtual read_if r_vif;
   virtual write_if w_vif;
   
   bit 	   direction = 0;  // Write = 0; Read 1;

   `uvm_component_utils_begin(rw_driver)
      `uvm_field_int(direction, UVM_DEFAULT | UVM_DEC)
   `uvm_component_utils_end

   function new(string name, uvm_component parent);
      super.new(name, parent);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
     
     
	 uvm_config_db #(int)::dump();
     uvm_config_db #(virtual read_if)::dump();
     uvm_config_db #(virtual write_if)::dump();
     
      uvm_config_db#(int)::get(this, "", "direction", direction);
      uvm_config_db#(virtual read_if)::get(this, "", "r_vif", r_vif);
      uvm_config_db#(virtual write_if)::get(this, "", "w_vif", w_vif);
     
      
      if (w_vif == null) begin
	 `uvm_fatal("CFGERR", "Interface for write i/f is not set");
      end

      
      if (r_vif == null) begin
	 `uvm_fatal("CFGERR", "Interface for read i/f not set");
      end

   endfunction: build_phase

   virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
     `uvm_info("DRV_CFG", $sformatf("Direction is: %0d", direction), UVM_MEDIUM);
   endfunction: start_of_simulation_phase

   virtual task run_phase(uvm_phase phase);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

      forever begin
	 seq_item_port.get_next_item(req);
         
         `uvm_info("DRV_RUN", {"\n", req.sprint()}, UVM_MEDIUM);
	 send(req);
	 seq_item_port.item_done();
 end
   endtask: run_phase

   virtual task send(rw_seq_item tr);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      if(direction == 0)
	write_data(tr);
      else
	read_data(tr);
   endtask: send

   virtual task write_data(rw_seq_item tr);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      //while(!w_vif.reset) @(w_vif.cb);
      `uvm_info("TRACE", $sformatf("%t, Write data ready", $time()), UVM_HIGH);
      tr.print();
      w_vif.cb.wren <= 1'b1;
      w_vif.cb.waddr <= tr.waddr;
      w_vif.cb.wdata <= tr.wdata;
      @(w_vif.cb);
      w_vif.cb.wren <= 1'b0;
   endtask: write_data

   virtual task read_data(rw_seq_item tr);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      //while(!r_vif.reset) @(r_vif.cb);
      r_vif.cb.rden <= 1'b1;
      r_vif.cb.raddr <= tr.raddr;

      @(r_vif.cb);//Launch
      r_vif.cb.rden <= 1'b0;
      @(r_vif.cb);//Drive from DUT
      @(r_vif.cb);//Capture in TB
      tr.rdata =  r_vif.cb.rdata;
      `uvm_info("TRACE", $sformatf("%t, Data read from memory", $time()), UVM_HIGH);
      tr.print();
   endtask: read_data
   
endclass: rw_driver

`endif
