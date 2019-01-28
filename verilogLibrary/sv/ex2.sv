/////////////////////////////////////////////////////////////
//File            : ex2.sv
//Description     : Demonstrate usage of within construct.
//Chapter         : Assertion
//Subsection      : within              
//TAGS            : within
//Keywords        : within
//EDA Playground  :
//                : Add below code to get w/f  
//                   initial
//                     begin
//                       $dumpfile("wave.vcd");
//                       $dumpvars;
//                     end
/////////////////////////////////////////////////////////////


module top;
   
   
   bit clk;
   bit reset;
   bit [2:0] count;
   bit 	     s2_7_m, s3_6_m;
   
   
   typedef enum bit [2:0] {STATE1, STATE2, STATE3, STATE4, STATE5, STATE6, STATE7, STATE8} state_e;
   
   state_e state;
   
   always
     #5 clk = ~clk;
   
   initial 
     $monitor("%t, state = %s", $time(), state.name());
   
   
   initial
     begin 
	clk = 0;
	reset = 0;
	@(negedge clk ) reset = 1;
     end
   
   initial
     begin
	wait(state== STATE8);
	@(posedge clk);
	wait(state== STATE8);
	#1 $finish();
     end
   
   always@(posedge clk)
     begin	
	if(!reset)
	  begin
	     state = STATE1;
             count <=0;
	  end
	else
	  begin
             count <= count + 1;
             case(count)
               'd0 : state <= STATE1;
               'd1 : state <= STATE2;
               'd2 : state <= STATE3;
               'd3 : state <= STATE4;
               'd4 : state <= STATE5;
               'd5 : state <= STATE6;
               'd6 : state <= STATE7;
               'd7 : state <= STATE8;
             endcase
	  end
	
     end
   
   //Clock will be set implicitly or explicitly by the property layer.
   sequence s2_7;
      (state == 2) ##1 (state == 3) ##1 (state == 4) ##1 (state == 5) ##1 (state == 6) ##1 (state == 7,  $display("%t, Sequence s2_7 has finished",$time()));
   endsequence
   
   sequence s3_6;
      (state == 3) ##1 (state == 4) ##1 (state == 5) ##1 (state == 6,  $display("%t, Sequence s3_6 has finished",$time()));
   endsequence
   
   
   sequence s2_7_s3_6;
      s3_6 within s2_7;
   endsequence
   
   property within_check;
      (state==STATE2) |=> s2_7_s3_6;
   endproperty
   
   test_1: assert property ( @(posedge clk) within_check)
     $display("%t, Property asserted",$time());
   
   
   test_2: assert property ( @(posedge clk)   (state==STATE3) |=>s3_6)
     $display("%t, Property s3_6 is matched after 1 cycle of matching the sequence",$time());
   
   
   test_3: assert property ( @(posedge clk)   (state==STATE2) |=>s2_7)
     $display("%t, Property s2_7 is matched after one cycle of matching the sequence.",$time());
   
   
   initial begin
      $dumpfile("dump.vcd");
      $dumpvars();
   end
   
endmodule
