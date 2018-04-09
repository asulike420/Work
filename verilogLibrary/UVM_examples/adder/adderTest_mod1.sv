import uvm_pkg::*;
`include "uvm_macros.svh"



//packet

class packet extends uvm_sequence_item;
  
  rand bit [7:0] a, b;
  rand bit doAdd;
  
    `uvm_object_utils_begin(packet)
  `uvm_field_int(a, UVM_ALL_ON | UVM_NOCOMPARE)
  `uvm_field_int(b, UVM_ALL_ON)
  `uvm_field_int(b, UVM_ALL_ON)
     `uvm_object_utils_end
  
    function new(string name = "packet");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
  
  
  
endclass




//packetSequence
class pkt_seq extends uvm_sequence#(packet);
  
  int item_count = 10;
  
  `uvm_object_utils(pkt_seq)
  function new(string name = "pkt_seq");
    super.new(name);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    `ifdef UVM_POST_VERSION_1_1
     set_automatic_phase_objection(1);
    `endif
  endfunction: new
  
    virtual task body();
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
       repeat(item_count) begin
	  
         `uvm_do(req);
       end
    endtask
 
  
endclass




//driver
class my_driver extends uvm_driver#(packet);
  
 virtual add_sub_if m_if;
  
  `uvm_component_utils(my_driver);
  
     function new(string name, uvm_component parent);
      super.new(name, parent);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
   endfunction: new
  
    function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      //Get interface;
      assert(uvm_resource_db#(virtual add_sub_if)::read_by_name("env", "abhay", m_if)); 
    endfunction
    
  virtual task run_phase(uvm_phase phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);

    forever begin
      seq_item_port.get_next_item(req);
      send();
  	  seq_item_port.item_done();
    end
  endtask: run_phase
  
  
  task send ();
        //phase.raise_objection(this);
    `uvm_info("LABEL", "Started run phase.", UVM_HIGH);
    begin
      int a = 8'h2, b = 8'h3;
      @(m_if.cb);
      m_if.cb.a <= req.a;
      m_if.cb.b <= req.b;
      m_if.cb.doAdd <= 1'b1;
      repeat(2) @(m_if.cb);
      `uvm_info("RESULT", $sformatf("%0d + %0d = %0d",
        a, b, m_if.cb.result), UVM_LOW);
    end
    `uvm_info("LABEL", "Finished run phase.", UVM_HIGH);
   // phase.drop_objection(this);
    
    
  endtask
  
  
endclass






//agent
class my_agent extends uvm_agent;

  int abhay_port = 0;
  int resource1;
  int resource2;
  typedef uvm_sequencer #(packet) my_sequencer;
  my_driver drv;
  my_sequencer seq;
  
  
  //Will be used with uvm_config_db , not required when using uvm_resource_db.
  `uvm_component_utils_begin(my_agent)
  `uvm_field_int(abhay_port,UVM_DEFAULT| UVM_DEC)
  `uvm_field_int(resource1, UVM_DEFAULT| UVM_DEC)
  `uvm_component_utils_end
  
      function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
      function void build_phase(uvm_phase phase);
     uvm_config_db#(int)::get(this,"","abhay_port",abhay_port);
        uvm_resource_db#(int)::read_by_name("agent","resource2",resource1);
        `uvm_info("INFO-Agent", $sformatf("%s\n", get_full_name()), UVM_LOW)
        uvm_resource_db#(int)::read_by_type("agent",resource2);
	 drv = my_driver::type_id::create("drv",this);
	 seq = my_sequencer::type_id::create("seq", this);
	 
	 
    endfunction    
  
  
    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
      drv.seq_item_port.connect(seq.seq_item_export);//pull interface
  endfunction: connect_phase
  
  
  
    task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info("RESULT", $sformatf("abhay_port=%d\n",abhay_port),UVM_LOW)
      `uvm_info("RESULT", $sformatf("resource1=%d\n",resource1),UVM_LOW)
      `uvm_info("RESULT", $sformatf("resource2=%d\n",resource2),UVM_LOW)
          phase.drop_objection(this);                           
	endtask                                    
    
  
  
endclass





//----------------
// environment env
//----------------
class env extends uvm_env;

  virtual add_sub_if m_if;
  my_agent agent;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      agent = my_agent::type_id::create("agent",this);
      uvm_config_db#(int)::set(this,"agent","abhay_port",10);
      uvm_resource_db#(int)::set("agent","resource",1);
      uvm_resource_db#(int)::set("agent","resource2",2);
      uvm_config_db #(uvm_object_wrapper)::set(this, "agent.seq.main_phase", "default_sequence", pkt_seq::get_type());
    endfunction
  
  
  function void connect_phase(uvm_phase phase);
    `uvm_info("LABEL", "Started connect phase.", UVM_HIGH);
    // Get the interface from the resource database.
    assert(uvm_resource_db#(virtual add_sub_if)::read_by_name(
      get_full_name(), "abhay", m_if));
    `uvm_info("INFO-env", $sformatf("%s\n", get_full_name()), UVM_LOW)
    `uvm_info("LABEL", "Finished connect phase.", UVM_HIGH);
     
  endfunction: connect_phase


  
endclass

//-----------
// module top
//-----------
module top;

  bit clk;
  env environment;
  ADD_SUB dut(.clk (clk));

  initial begin
    environment = new("env");
    // Put the interface into the resource database.
    uvm_resource_db#(virtual add_sub_if)::set("env",
      "abhay", dut.add_sub_if0);
    clk = 0;
    run_test();
  end
  
  initial begin
    forever begin
      #(50) clk = ~clk;
    end
  end
  
  initial begin
    // Dump waves
    $dumpvars(0, top);
  end
  
endmodule
