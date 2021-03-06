module memory256x8(mem_if.dut i);
   
   parameter ADDR_WIDTH=10;
   parameter DATA_WIDTH=32;

   reg [DATA_WIDTH-1:0] mem [ADDR_WIDTH-1:0];

//Read   
always @(posedge i.clk)
  begin
     if(i.rden) begin
	i.data_out <= mem[i.addr_in];
     end
   end
   


//Write
always @(posedge i.clk)
  begin
     if(i.wren) begin
	mem[i.addr_in] <= i.data_in;
     end
  end
   
   
endmodule // memory256x8



interface mem_if(input bit clk);

   logic [7:0] addr_wr, addr_rd, addr_in;
   logic [7:0] data_in, data_out;
   logic       wren, rden;

   clocking cb @(posedge clk);
      input    data_out;
      output   data_in, addr_in, wren,rden;
      
   endclocking // cb

   modport tb(input clk,clocking cb);
   modport dut(input clk,input data_in, addr_in, wren,rden, output data_out);
   
endinterface // mem_if


module top;

   logic clk;

   mem_if if1(clk);
   memory256x8 #(.ADDR_WIDTH(8), .DATA_WIDTH(8)) dut(if1);
   
   
   initial clk =0;
   always #5 clk = ~clk;

   

endmodule // top

class transaction;

   rand logic [2:0] addr_in;

   rand logic [7:0]  data_in;
   rand bit wren, rden;
   
endclass // transaction


program test;

   virtual mem_if.tb vif;
   transaction writeTrans[$];
   logic [7:0] expData[$],  actualData[$];
   mailbox gen2drv;
   event   mon2scb, drv2mon;
   
     

   initial begin
      transaction transGen, transDrv;
      vif = top.if1;
      gen2drv = new();
      
      


      //////------DRIVER      
      
      fork
	 //Driver, Write expected data -- Get signal from to kill the thread.
	 begin
	    int count = 0;
	    int numOfTran = 3;	    
	    while (numOfTran) begin//: "Write Memory"
	       $display("DRIVER::Retrieving data from MailBox");	    
	       gen2drv.get(transDrv);
	       //Call  task to send to drive the interface.
	       @vif.cb; //Use first line in the driver , so as to not miss the first packet.
	       vif.cb.data_in <= transDrv.data_in;
	       vif.cb.addr_in <= transDrv.addr_in;
	       vif.cb.wren <= 1'b1;
	       writeTrans.push_front(transDrv);//Scoreboard expected que
	       expData.push_front(transDrv.data_in);
	       $display("DRIVER WRITE",numOfTran);	    
	       numOfTran--;	    
	    end // while (1)

	    begin //:"Read Memeory" 
	       int count = 0;
	       int numOfTran = 3;
	       int syncCount = 2;//Nuber of cycles after which output monitor should start captuing read value.
	       //wait(drv2mon.triggered);
	       $display("DRIVER READ:: Starting read op");
	       @vif.cb;
	       foreach(writeTrans[i]) begin 
	       //while(numOfTran) begin
		  numOfTran--;
		  @vif.cb;
		  vif.cb.addr_in <= writeTrans[i].addr_in;
		  vif.cb.wren <= 1'b0;
		  vif.cb.rden <= 1'b1;
		  //Trigger event to start Monitor
		  count = count +1 ;
		  if (count == syncCount) begin
		     ->drv2mon; // clk-putData-clk2-sampleAndPutData-clk3-startMon to sample data.
		     //$display($time);
		     $display("Triggering  Monitor to start capturing data");
		     
		  end
		  
	       end
	    end

	 end
      join_none


      
      /////------GENERATOR
      for (int i = 0; i < 10 ; i++) begin
	 transGen = new();
	 assert(transGen.randomize());
	 gen2drv.put(transGen);
      end


      /////------MONITOR

      //Monitor interface for to recieve actual data.
      //Check data initially without forking , but large arays needs to be stored .. Using excessive memory.
      //      fork
      begin//:"Monitor"
	 int numOfTran = 3;
	 wait(drv2mon.triggered);//Check time when the trigger is recieved. Need to check how we can efficiently capture the next edge.
	 $display("%t, Monitor::Recieved trigger",$time);
	 while(numOfTran)begin
	    @vif.cb;//Check this clock edge is not the same as when trigger was recieved.
	    $display(vif.cb.data_out);
	    actualData.push_back(vif.cb.data_out);
	    numOfTran--;
	 end
	 $display("Monitor:: Triggering to start Scoreboard");
	 ->mon2scb;
      end
      

      //      join


      
      //Scoreboard start when Monitor has collected all the data.
      
      begin// : "Scoreboard"
	 /*Initiall just match the corresponding array 
	  Case 1:: Compare expected and actual array. Memory not eficiently used.
	  Case 2:: Search actual data with expected data and delete once matched. Can be used as mechanism for caling test done.
	  Case 3:: Compare data as soon as it is recieved and delete the element from the que. Since deletion of transaction from the expected que does not have to wait till end of the test , it is least memory consuming.
	  */
	 //	 transacton checkAddr[$];
	 //	 int numOfTr, count;
	 //	 count = 0;
	 //	 
	 //	 numOfTr = checkAddr.size();
	 //	 foreach()
	 //	   wait(mon2scb.trigger());
	 //	 foreach(expTran) begin
	 //	    checkAddr = actualTran.find with (item.addr_in == expTran.addr);
	 //	    count = count + 1;
	 //	    if (count == numOfTr) break;

	 //Case1:: Wait for the Monitor to sample all of the actual data.
	 wait(mon2scb.triggered);
	 $display("SCB:: Recieved trigger to start scoreboarding");
	 if(expData == actualData) $display("Success");
	 else $display("Error:: Mismatch Data");
	 $display("Finished Simulation");
	 $display(expData,"\n",actualData);
	 $writememh("memDump",top.dut.mem);
	 
	 
      end


      
   end
   
   


endprogram 

   
