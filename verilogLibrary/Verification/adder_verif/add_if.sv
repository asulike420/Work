
interface add_if(input clk, reset);

   logic [31:0] a, b;
   logic [32:0] sum;

   clocking drv_cb(@posedge clk);
      output    a, b;
      input     sum;
   endclocking // drv_cb

   clocking mon_cb(@posedge clk);
      output    a, b;
      output    sum;
   endclocking // drv_cb

   modport DRIVER (clocking drv_cb, input clk, reset);
   modport MONITOR(clocking mon_cb, input clk, reset);

endinterface // add_if
