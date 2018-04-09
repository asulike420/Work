




interface if1(input bit clk);
  logic [7:0] data;
  logic [3:0] addr;
  bit wren;

   clocking cb @(posedge clk);
      
      inout data;
      output addr, wren;
   endclocking
   
endinterface



module mem_1(if1 ifInst);
  
  //bit ifInst.clk ;
  reg [7:0] mem [0:15];
  
  initial $monitor("%t wren=%h: addr=%h; data=%h", $time ,ifInst.wren, ifInst.addr, ifInst.data);
  
  always @(posedge ifInst.clk)
    if(ifInst.wren)
      mem[ifInst.addr] <= ifInst.data;
    else
      ifInst.data <= mem[ifInst.addr];

endmodule // mem_1

class Packet;

   randc logic [7:0] data[];
   randc logic [3:0] addr[];

   constraint lenCons{
     data.size() < 15;
      data.size() == addr.size();

}

endclass // Packet


module top;
   bit clk;
   Packet pkt;
  logic [7:0] readData[$];
   
   
   if1 ifDUT(clk);
  mem_1 DUT(.ifInst(ifDUT));
  
   initial clk = 0;
   always #5 clk = ~clk;

   initial begin;
      pkt = new;
      assert(pkt.randomize());
     #10
     foreach(pkt.addr[i])begin
       @ifDUT.cb
	 ifDUT.cb.wren <= 1;
        ifDUT.cb.addr <= pkt.addr[i];
        ifDUT.cb.data <= pkt.data[i];
	 
	 
      end
     // @ifDUT.cb;
      fork
	 begin
       //@ifDUT.cb;
       foreach(pkt.addr[i]) begin
         @ifDUT.cb
	 ifDUT.cb.wren <= 1'b0;
         ifDUT.cb.addr <= pkt.addr[i];
	 
	 
      end
	 end
	 begin
	    
	    @ifDUT.cb;
      // readData= new[1];
	    @ifDUT.cb;
       foreach(pkt.data[i])begin
         @ifDUT.cb;
         readData.push_back(ifDUT.cb.data);
	      
	       
	       end
	    
	 end
	 join

     $display("%p \n%p\n  %p", pkt.addr, pkt.data, readData);
	 
   end
   

      
   

endmodule // top









interface if1(input bit clk);
  logic [7:0] data;
  logic [3:0] addr;
  bit wren;

   clocking cb @(posedge clk);
      
      inout data;
      output addr, wren;
   endclocking
   
endinterface



module mem_1(if1 ifInst);
  
  //bit ifInst.clk ;
  reg [7:0] mem [0:15];
  
  initial $monitor("%t wren=%h: addr=%h; data=%h", $time ,ifInst.wren, ifInst.addr, ifInst.data);
  
  always @(posedge ifInst.clk)
    if(ifInst.wren)
      mem[ifInst.addr] <= ifInst.data;
    else
      ifInst.data <= mem[ifInst.addr];

endmodule // mem_1

class Packet;

   randc logic [7:0] data[];
   randc logic [3:0] addr[];

   constraint lenCons{
     data.size() < 15;
      data.size() == addr.size();

}

endclass // Packet


module top;
   bit clk;
   Packet pkt;
  logic [7:0] readData[$];
   
   
   if1 ifDUT(clk);
  mem_1 DUT(.ifInst(ifDUT));
  
   initial clk = 0;
   always #5 clk = ~clk;

   initial begin;
      pkt = new;
      assert(pkt.randomize());
     #10
     foreach(pkt.addr[i])begin
	 ifDUT.cb.wren <= 1;
        ifDUT.cb.addr <= pkt.addr[i];
        ifDUT.cb.data <= pkt.data[i];
	 @ifDUT.cb;
	 
      end
     // @ifDUT.cb;
      fork
	 begin
       //@ifDUT.cb;
       foreach(pkt.addr[i]) begin
	 ifDUT.cb.wren <= 1'b0;
         ifDUT.cb.addr <= pkt.addr[i];
	 @ifDUT.cb;
	 
      end
	 end
	 begin
	    @ifDUT.cb;
	    @ifDUT.cb;
      // readData= new[1];
	    
       foreach(pkt.data[i])begin
         readData.push_back(ifDUT.cb.data);
	       @ifDUT.cb;
	       
	       end
	    
	 end
	 join

     $display("%p \n%p\n  %p", pkt.addr, pkt.data, readData);
	 
   end
   

      
   

endmodule // top



