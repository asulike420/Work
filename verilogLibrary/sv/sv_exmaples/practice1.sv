module mem16_8(mem_if.if_DUT if1);

  reg [7:0] mem [0:3];

  initial $monitor("%t data= %b rd_addr = %b rden=%b rd_data=%b", $time,mem[0], if1.rd_addr, if1.rden,if1.rd_data);
 // initial $monitor ("rd_addr = %b\n", if1.rd_addr);
  //initial $monitor ("rden=%b\n",if1.rden);
  
   always @(posedge if1.clk)
     begin
       if(if1.wren)begin
       //  assert (!if1.wren) else $display("Writting\n");
	mem[if1.wr_addr] <= if1.wr_data;
       end
     end

   always @(posedge if1.clk)
     begin
	if(if1.rden) begin
      //$display("reading\n");
	  if1.rd_data <= mem[if1.rd_addr];
	   if1.ovalid <= 1'b1;
	end
	else
	  if1.ovalid <= 1'b0;
     end

  
endmodule // mem




interface mem_if(input bit clk);

   logic [3:0 ] wr_addr, rd_addr;
   logic [7:0] 	wr_data, rd_data;
   logic 	wren, rden, ovalid;

   clocking cb @(posedge clk); // Used to time signals using @cb 
   default input #1step output #4;
      output 	wr_addr, rd_addr, wren, rden, wr_data;
      input 	rd_data, ovalid;
   endclocking

   modport if_DUT(input wr_addr, rd_addr, wren, rden, wr_data, clk, output rd_data, output ovalid);

  modport if_TB(clocking cb);
   

endinterface // mem_if




//module top

module top;

   reg clk;
   mem_if if_inst(clk);
   mem16_8 DUT (if_inst.if_DUT);
   
   initial clk = 0;

   always #5 clk = ~clk;


   initial begin
     
     
     #10
       if_inst.cb.wr_data <= 8'd10;
      if_inst.cb.wren <= 1'b1;
      if_inst.cb.wr_addr <= 4'd0;
           if_inst.cb.rd_addr <= 4'd0;
      if_inst.cb.rden <= 1'b0;
      @(if_inst.cb);
     //if_inst.cb.wren <= 1'b0;
     @(if_inst.cb);
    // #5
	 if_inst.cb.wren <= 1'b0;
      if_inst.cb.rd_addr <= 4'd0;
      if_inst.cb.rden <= 1'b1;
     //$display("********Abhay******************\n");
      @(if_inst.cb);
     @(if_inst.cb);
     $display("Abhay");
    // #5
      $displayb(if_inst.cb.rd_data);
       @(if_inst.cb);
     $finish();
      end 

endmodule 
