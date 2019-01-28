

interface fsm_ports(input logic clk);
   

   logic get_data;
   logic reset_;
   logic [7:0] data;
   logic       rd;
   logic       sipo_en, latch_en;
   logic       dp1_en, dp2_en, dp3_en, dp4_en, wr;
   logic       done_frame;
   logic [17:0] rd_addr;


   //Clocking Block - Used by TB for monitoring and driving stable data 
   default clocking cb @(posedge clk) ; //Need to check the default keyword is in effect or not.
     default input #1step output negedge;
      output 	get_data;
      output	reset_;
      output     data;
      input 	  rd;
      input sipo_en, latch_en;
      input dp1_en, dp2_en, dp3_en, dp4_en, wr;
      input done_frame;
      input rd_addr;
   endclocking  
   
   
endinterface


module test_fsm;

   logic clk;
   logic [6:0] addr_cnt;
   
   fsm_ports if1(clk);
   fsm dut(
	   if1.get_data, if1.reset_, if1.clk, if1.rd, if1.rd_addr,
	   if1.data , if1.done_frame, if1.latch_en, if1.sipo_en, if1.dp1_en,
	   if1.dp2_en, if1.dp3_en, if1.dp4_en, if1.wr
	   );


   initial
     begin
	clk = 0;
	forever #5 clk = ~clk; 
     end


  
initial
  begin
     addr_cnt  <= 0;
     @if1.cb if1.cb.reset_ <= 0; if1.cb.get_data <= 0; if1.cb.data <= 0;
     @if1.cb if1.cb.reset_ <= 1;
     @if1.cb if1.cb.get_data <= 1;
     
//     repeat (64) begin 
//	@if1.cb  if1.rd_addr  <= addr_cnt;
//	addr_cnt <= addr_cnt + 1;
//     end

    repeat (500) @if1.cb;
    $finish();
     
  end
   
   

   
endmodule
