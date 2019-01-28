// Code your design here
// Code your testbench here
// or browse Examples
module fsm (get_data, reset_, clk, rd, rd_addr,
data , done_frame, latch_en, sipo_en, dp1_en,
dp2_en, dp3_en, dp4_en, wr);
  
input get_data;
input reset_;
input clk;
input [7:0] data;
output rd;
output logic sipo_en, latch_en;
output logic dp1_en, dp2_en, dp3_en, dp4_en, wr;
output logic done_frame;
output [17:0] rd_addr;
logic [5:0] addr_cnt;
logic [11:0] blk_cnt;
logic [3:0] pipeline_cnt;
logic rd;
logic [17:0] rd_addr;
logic enable_cnt, enable_dly_cnt, enable_blk_cnt;

  
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0);
end
  
  
  
assign done_frame = (blk_cnt == 4095);
assign sipo_en = rd;
  
  enum bit[15:0] {
    IDLE = 16'd1,
GEN_BLK_ADDR = 16'd2,
DLY = 16'd4,
NEXT_BLK = 16'd8,
WAITO = 16'd16,
CNT1 = 16'd32,
WAIT1 = 16'd64,
CNT2 = 16'd128,
WAIT2 = 16'd256,
CNT3 = 16'd512,
WAIT3 = 16'd1024,
CNT4 = 16'd2048,
WAIT4 = 16'd4096,
CNT5 = 16'd8192,
WAIT5 = 16'd16384,
CNT6 = 16'd32768} n_state, c_state;
                     
 // assign the different control signals
  assign latch_en = (c_state == CNT1);
  assign dp1_en = (c_state == CNT2);
  assign dp2_en = (c_state == CNT3);
  assign dp3_en = (c_state == CNT4);
  assign dp4_en = (c_state == CNT5);
  assign wr = (c_state == CNT6);
// 64bit counter to generate read address
  always_ff @(posedge clk)
if (!reset_ || !enable_cnt)
addr_cnt <= 0;
else if (enable_cnt)
addr_cnt <= addr_cnt + 1;
else
addr_cnt <= addr_cnt;
// 4096 bit counter
  always_ff @(posedge clk)
if (!reset_)
blk_cnt <= 0;
else if ((c_state == NEXT_BLK) && enable_blk_cnt)
blk_cnt <= blk_cnt + 1 ;
else
blk_cnt <= blk_cnt;
  always_ff @(posedge clk)
if (!reset_)
c_state <= IDLE;
else
c_state <= n_state;
always @(*)
begin
rd <= 0;
enable_cnt <= 0;
//enable_dly_cnt <= 0;
case (c_state)
IDLE: begin
enable_blk_cnt <= 0;
  if(get_data)
n_state <= GEN_BLK_ADDR;
else
n_state <= IDLE;
end
GEN_BLK_ADDR: begin
enable_cnt <= 1;
rd <= 1;
rd_addr <= {blk_cnt, addr_cnt};
  if (addr_cnt == 63) begin
//enable_dly_cnt <= 1;
n_state <= WAITO;
end
else begin
n_state <= GEN_BLK_ADDR;
//pipeline_cnt <= 0;
end
end
WAITO: n_state <= CNT1;
CNT1: n_state <= WAIT1;
WAIT1: n_state <= CNT2;
CNT2: n_state <= WAIT2;
WAIT2: n_state <= CNT3;
CNT3: n_state <= WAIT3;
WAIT3: n_state <= CNT4 ;
CNT4: n_state <= WAIT4;
WAIT4: n_state <= CNT5;
CNT5: n_state <= WAIT5;
WAIT5: n_state <= CNT6;
CNT6: n_state <= DLY;
DLY: begin
enable_blk_cnt <= 1;
n_state <= NEXT_BLK;
end
NEXT_BLK: begin
enable_blk_cnt<=1;
if (blk_cnt == 4095)
n_state <= IDLE;
  
  else
n_state <= GEN_BLK_ADDR;
end
endcase
end
endmodule
                     