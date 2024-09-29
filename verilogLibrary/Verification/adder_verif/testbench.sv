//-------------------------------------------------------------------------
//				www.verificationguide.com   testbench.sv
//-------------------------------------------------------------------------
//---------------------------------------------------------------
//including interfcae and testcase files
`include "add_if.sv"
`include "adder_seq_item.sv"
`include "adder_driver.sv"
`include "adder_monitor.sv"
`include "adder_agent.sv"
`include "adder_env.sv"
`include "adder_test.sv"




module tbench_top;

   //---------------------------------------
   //clock and reset signal declaration
   //---------------------------------------
   bit clk;
   bit reset;

   //---------------------------------------
   //clock generation
   //---------------------------------------
   always #5 clk = ~clk;

   //---------------------------------------
   //reset Generation
   //---------------------------------------
   initial begin
      reset = 1;
      #5 reset =0;
   end

   //---------------------------------------
   //interface instance
   //---------------------------------------
   adder_if intf(clk,reset);

   //---------------------------------------
   //DUT instance
   //---------------------------------------
   adder DUT (
               .clk(intf.clk),
               .reset(intf.reset),
               .a(intf.a),
               .b(intf.b),
               .sum(intf.sum),
     );

   //---------------------------------------
   //passing the interface handle to lower heirarchy using set method
   //and enabling the wave dump
   //---------------------------------------
   initial begin
      uvm_config_db#(virtual adder_if)::set(uvm_root::get(),"*","vif",intf);
      //enable wave dump
      $dumpfile("dump.vcd");
      $dumpvars;
   end

   //---------------------------------------
   //calling test
   //---------------------------------------
   initial begin
      run_test();
   end

endmodule
