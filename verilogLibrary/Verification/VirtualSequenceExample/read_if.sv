interface read_if( input bit clk);

   bit [7:0] rdata;
  bit [3:0] raddr;
   bit 	     rden;


   clocking cb @(posedge clk);
      input  rdata;
      output raddr, rden;
   endclocking // cb
   
endinterface // read_if
