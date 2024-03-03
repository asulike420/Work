////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s        SystemVerilog Tutorial        s////
////s                                      s////
////s           gopi@testbench.in          s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

  module top();
      reg clk = 0;
      initial  // clock generator
      forever #5 clk = ~clk;
      
      // DUT/assertion monitor/testcase instances
      intf_cnt intf(clk);
      ones_counter DUT(clk,intf.reset,intf.data,intf.count);
      testcase test(intf);
      assertion_cov acov(intf);
   endmodule
