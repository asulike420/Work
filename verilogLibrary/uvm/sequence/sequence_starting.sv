
class seq_item extends uvm_sequence_item;
   string message = "Hello abhay";
   `uvm_component_utils(seq_item)
   function new (string name = "");
      super.new(name);
   endfunction // new
endclass // seq_item

class sequence extends uvm_sequence;
   seq_item  item;
   `uvm_object_utils(sequence)
      function new (string name = "");
	 super.new(name);
      endfunction // new

      task body();
	 `uvm_do(item)
      endtask // body
      
   endclass // seq_item

class driver extends uvm_driver#(seq_item);
   `uvm_component_utils(driver);
   function new(string name = "", uvm_component parrent = null);
      super.new(name, parrent);
   endfunction // new

   task run_phase(uvm_phase phase);
      forever begin
	 seq_item_port.get(req);
	 $display(req.message);
      end
   endtask // run_phase
         
endclass // driver

class test extends uvm_test;

   uvm_sequencer#(seq_item) sqr;
   driver drv;
      
   `uvm_component_utils(test)
   
   function new (string name ="", uvm_component parrent = null);
      super.new(name, parrent);
   endfunction // new

   function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(sqr.seq_item_export);
   endfunction // connect_phase
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sqr = uvm_sequencer::type_id::create();
   endfunction // void
   
   task run_phase(uvm_phase phase);
      my_sequence seq = sequence::type_id::create("sequence");
	 phase.raise_objection();
	 seq.start(sqr);
	 phase.drop_objection(phase);
      endtask // run_phase
   
   
endclass
   
