
module top;
  parameter int NumRx = `RxPorts;
  parameter int NumTx = `TxPorts;
  logic rst, clk;
  // System Clock and Reset
  initial begin
    rst = 0; clk = 0;
    #5ns rst = 1;
    #5ns clk = 1;
    #5ns rst = 0; clk = 0;
    forever
      #5ns clk = ~clk;
  end
Utopia Rx[0:NumRx-1] ();// NumRx x Level 1 Utopia Rx Interface Utopia Tx[0:NumTx-1] ();// NumTx x Level 1 Utopia Tx Interface cpu_ifc mif(); // Utopia management interface
squat #(NumRx, NumTx) squat(Rx, Tx, mif, rst, clk); // DUT test #(NumRx, NumTx) t1(Rx, Tx, mif, rst, clk); // Test
endmodule : top
