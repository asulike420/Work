
//-------------------------------------------------------------------------
//						adder_scoreboard - www.verificationguide.com
//-------------------------------------------------------------------------

 class adder_scoreboard extends uvm_scoreboard;

   //---------------------------------------
   // declaring pkt_qu to store the pkt's recived from monitor
   //---------------------------------------
   adder_seq_item pkt_qu[$];

 //---------------------------------------
   //port to recive packets from monitor
   //---------------------------------------
   uvm_analysis_imp#(adder_seq_item, adder_scoreboard) item_collected_export;
   `uvm_component_utils(adder_scoreboard)

   //---------------------------------------
   // new - constructor
   //---------------------------------------
   function new (string name, uvm_component parent);
     super.new(name, parent);
   endfunction : new

   //---------------------------------------
   // build_phase - create port and initialize local adderory
   //---------------------------------------
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
       item_collected_export = new("item_collected_export", this);
       foreach(sc_adder[i]) sc_adder[i] = 8'hFF;
   endfunction: build_phase

   //---------------------------------------
   // write task - recives the pkt from monitor and pushes into queue
   //---------------------------------------
   virtual function void write(adder_seq_item pkt);
     //pkt.print();
     pkt_qu.push_back(pkt);
   endfunction : write

   //---------------------------------------
   // run_phase - compare's the read data with the expected data(stored in local adderory)
   // local adderory will be updated on the write operation.
   //---------------------------------------
    virtual task run_phase(uvm_phase phase);
       adder_seq_item adder_pkt;

       forever begin
          wait(pkt_qu.size() > 0);
          adder_pkt = pkt_qu.pop_front();

          // if(adder_pkt.wr_en) begin
          //    sc_adder[adder_pkt.addr] = adder_pkt.wdata;
          //    `uvm_info(get_type_name(),$sformatf("------ :: WRITE DATA       :: ------"),UVM_LOW)
          //    `uvm_info(get_type_name(),$sformatf("Addr: %0h",adder_pkt.addr),UVM_LOW)
          //    `uvm_info(get_type_name(),$sformatf("Data: %0h",adder_pkt.wdata),UVM_LOW)
          //    `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          //    endadder_
          //      else if(adder_pkt.rd_en) begin
          //         if(sc_adder[adder_pkt.addr] == adder_pkt.rdata) begin
          //            `uvm_info(get_type_name(),$sformatf("------ :: READ DATA Match :: ------"),UVM_LOW)
          //            `uvm_info(get_type_name(),$sformatf("Addr: %0h",adder_pkt.addr),UVM_LOW)
          //            `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_adder[adder_pkt.addr],adder_pkt.rdata),UVM_LOW)
          //            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          //         end
          //         else begin
          //            `uvm_error(get_type_name(),"------ :: READ DATA MisMatch :: ------")
          //            `uvm_info(get_type_name(),$sformatf("Addr: %0h",adder_pkt.addr),UVM_LOW)
          //            `uvm_info(get_type_name(),$sformatf("Expected Data: %0h Actual Data: %0h",sc_adder[adder_pkt.addr],adder_pkt.rdata),UVM_LOW)
          //            `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
          //         end // else: !if(sc_adder[adder_pkt.addr] == adder_pkt.rdata)
          //
          //      end // if (adder_pkt.rd_en)
          //
          // end // if (adder_pkt.wr_en)

       endtask : run_phase
 endclass : adder_scoreboard
