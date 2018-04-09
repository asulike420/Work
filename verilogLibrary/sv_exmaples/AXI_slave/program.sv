program test;

   virtual axi_slave_if vif;

   initial vif = top.if1;

   initial begin
      vif.rstn <= 1'b0;
      repeat (2) @(posedge clk);
      vif.rstn <= 1'b1;
      end

endprogram // test

   
