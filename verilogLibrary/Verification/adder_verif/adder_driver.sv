

`define DRIV_IF vif.DRIVER.driver_cb

class adder_driver extends uvm_driver #(adder_seq_item);

   // Virtual Interface
   virtual      adder_if vif;

   `uvm_component_utils(adder_driver)

   //uvm_analysis_port #(adder_seq_item) Drvr2Sb_port;

   // Constructor
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual adder_if)::get(this, "", "vif", vif))
        `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
   endfunction: build_phase

   // run phase
   virtual task run_phase(uvm_phase phase);
      forever begin
         seq_item_port.get_next_item(req);
         //respond_to_transfer(req);
         drive();
         seq_item_port.item_done();
      end
   endtask : run_phase

   // drive
   virtual task drive();
      req.print();
      `DRIV_IF.a <= req.a;
      `DRIV_IF.b <= req.b;
      @(posedge vif.DRIVER.clk);
      $display("-----------------------------------------");
   endtask : drive

endclass : adder_driver
