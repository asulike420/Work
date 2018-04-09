////////////////////////////////////////////////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////s           www.testbench.in           s////
////s                                      s////
////s        SystemVerilog Tutorial        s////
////s                                      s////
////s           gopi@testbench.in          s////
////s~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s////
////////////////////////////////////////////////

  class monitor;
          scoreboard sb;
          virtual intf_cnt intf;
          
          function new(virtual intf_cnt intf,scoreboard sb);
               this.intf = intf;
               this.sb = sb;
          endfunction
          
          task check();
              forever
              @ (negedge intf.clk)
              if(sb.store != intf.count) // Get expected value from scoreboard and compare with DUT output
                  $display(" * ERROR * DUT count is %b :: SB count is %b ", intf.count,sb.store );
              else
                  $display("           DUT count is %b :: SB count is %b ", intf.count,sb.store );
          endtask
    endclass
