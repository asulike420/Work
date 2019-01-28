class read_seq_c extends uvm_sequence #(rw_seq_item);

`uvm_object_utils(read_seq_c)

   function new (string name = "read_seq_c");
      super.new(name);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
           `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
     `endif
   endfunction // new

   task body();

      for(int i = 0; i < 16 ; i ++)
	begin
	`uvm_do_with(req, {
			   req.raddr == i;
			   req.rden == 1;})
	end
      
   endtask // body
   


endclass // read_seq


class write_seq_c extends uvm_sequence #(rw_seq_item);

`uvm_object_utils(write_seq_c)

   function new (string name = "write_seq_c");
      super.new(name);
      `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
           `ifdef UVM_POST_VERSION_1_1
      set_automatic_phase_objection(1);
     `endif
   endfunction // new

   task body();

      for(int i = 0; i < 16 ; i ++)
	begin
	`uvm_do_with(req, {
			   req.wdata == i;
			   req.waddr == i;
			   req.wren == 1;})
	end
      
   endtask // body
   


endclass // write_seq
