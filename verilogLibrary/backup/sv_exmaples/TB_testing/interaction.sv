class transaction ;

   rand logic [31:0] data;
   int subid;
   int tr_num;
   
   
endclass // transaction


class driver;

   mailbox gen2drv, drv2gen;
   
   function new(mailbox gen2drv, drv2gen);
      this.gen2drv = gen2drv;

      this.drv2gen = drv2gen;
      if (this.gen2drv == null)
	$error("handle not obtained");
      
   endfunction // new
   
   task start_drive();
      fork
	 drive();
      join_none
      
   endtask // start_drive
   
   task drive();
      forever begin
	
	 transaction tr;
	 #5;
	 
	 gen2drv.get(tr);

	 $display("%t Driver tr.subid=%d, tr.data=%d",$time ,tr.subid, tr.data);
	 drv2gen.put(tr.subid);
	 
	   //@(posedge top.clk);
	 //#5;
	 
	 
      end
   endtask // drive
   
     
     endclass // driver



class generator;

   rand int num_trans;
   int subid_q[$];
   mailbox gen2drv;
   mailbox drv2gen;
   

   function new (mailbox gen2drv, drv2gen);
      this.gen2drv = gen2drv;
      this.drv2gen = drv2gen;
      subid_q = {1, 2};
      
   endfunction // new

   task start_gen();
      fork
	 retrieve_subid();
      join_none

      fork
	 send_tr();
      join
      
   endtask // start_gen
   

   task retrieve_subid();
      int i;
      drv2gen.get(i);
      subid_q.push_back(i);
   endtask // retrieve_subid
   
   
   task send_tr();
      int count = 0;
      
      $display("Number of Transactions to be sent %d",num_trans);
      
      //repeat (num_trans) begin
      repeat (4) begin
	 transaction tr;
	 $display("%t len subid_q = %d" , $time, $size(subid_q));
	 
	 wait($size(subid_q));
	 tr = new();
	 assert(tr.randomize());
	 tr.subid = subid_q.pop_front();
	 tr.tr_num = count;
	 $display("%t Gen tr.subid=%d, tr.data=%d",$time ,tr.subid, tr.data);
	 gen2drv.put(tr);
	 count ++;
      end
   endtask // send_tr
   

endclass // generator


program test;

   driver drv;
   generator gen;
   mailbox drv2gen;

   mailbox  gen2drv;

   initial begin
      drv2gen  = new();
      gen2drv  = new();
      drv = new (gen2drv, drv2gen );
      gen = new(gen2drv, drv2gen);

      assert(gen.randomize());
      drv.start_drive();
      gen.start_gen();
      
      
      
   end
   

endprogram // test
   
