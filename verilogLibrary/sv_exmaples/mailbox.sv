

program test;
  mailbox my_box;
  logic [7:0] data,data_1;
  logic [7:0] data_q [$];
  initial begin 
    my_box = new();
    fork
      begin : Label1
        for (int i = 0; i < 10 ;i++) begin
          data = $random();
	  
          #10
	       $display("%t Mailing data", $time);
          $displayh(data);
          my_box.put(data);
        end
        disable Label2;
      end
      
      begin : Label2
      	forever begin
          #5
          $display("%t Retriving data", $time);
          my_box.get(data_1);
          
          //if(data_1 != null)
            data_q.push_back(data_1);
        end
      end
      
    join
    
    $display("Reciveed pckets %p",data_q);
    

    
  end
endprogram
