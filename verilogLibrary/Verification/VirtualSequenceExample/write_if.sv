interface write_if(input bit clk);

   bit [7:0] wdata;
   bit [3:0] waddr;
   bit 	     wren;


   clocking cb  @(posedge clk);
      output wdata, wren, waddr;
   endclocking // cb
   
endinterface // read_if

