module top;

   bit clk;
  
  
   read_if r_if(clk);
   write_if w_if(clk);
  
   mem dut(.clk(clk),
	   .waddr(w_if.waddr),
	   .wdata(w_if.wdata),
	   .wren(w_if.wren),
	   .raddr(r_if.raddr),
	   .rdata(r_if.rdata),
	   .rden(r_if.rden)
	   ) ;
   
   
   initial
     clk = 0;

   initial
     forever #5 clk = ~clk;


   initial
   begin 
     uvm_resource_db#(virtual read_if)::set("read_vif", "", r_if);
     uvm_resource_db#(virtual write_if)::set("write_vif", "", w_if);
     run_test("test_base");
   end
  
         initial begin
      $dumpfile("dump.vcd");
      $dumpvars();
   end

endmodule // top
