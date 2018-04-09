`define clkedge @(posedge top.clk);



interface axi_slave_if(	input clk);
   
   parameter AXI_ID_WIDTH = 4;
   
   
logic           rstn;

// AXI write address channel
logic   [31:0]  i_awaddr;
logic   [AXI_ID_WIDTH-1:0]   i_awid;
logic   [3:0]   i_awlen;
logic           i_awvalid;
logic         o_awready;

// AXI write data channel
logic   [31:0]  i_wdata;
logic   [AXI_ID_WIDTH-1:0]   i_wid;
logic   [3:0]   i_wstrb;
logic           i_wlast;
logic           i_wvalid;
logic         o_wready;
logic [AXI_ID_WIDTH-1:0]   o_bid;
logic [1:0]   o_bresp;
logic         o_bvalid;
logic           i_bready;

// AXI read address channel
logic   [31:0]  i_araddr;
logic   [AXI_ID_WIDTH-1:0]   i_arid;
logic   [3:0]   i_arlen;
logic           i_arvalid;
logic         o_arready;

// AXI read data channel
logic [31:0]  o_rdata;
logic [AXI_ID_WIDTH-1:0]   o_rid;
logic [1:0]   o_rresp;
logic         o_rlast;
logic         o_rvalid;
logic           i_rready;


   clocking cb @(posedge clk);
      output 	i_awaddr;
      output 	i_awid;
      output 	i_awlen;
      output 	i_awvalid;
      input 	o_awready;

      // AXI write data channel
      output 	i_wdata;
      output 	i_wid;
      output 	i_wstrb;
      output 	i_wlast;
      output 	i_wvalid;
      input 	o_wready;
      input 	o_bid;
      input 	o_bresp;
      input 	o_bvalid;
      output 	i_bready;

   endclocking 

   modport TEST(output rstn, clocking cb);
   
   
endinterface // axi_slave_if


module top;


   reg clk;
   initial clk = 0;
   
   always #5 clk = ~clk;
   
       
   //instantiate interface
   axi_slave_if if1(clk);
      
   //instantiate and conect DUT
   axi_slave DUT (

	 	.clk(clk),
		.rstn(if1.rstn),
		.i_awaddr(if1.i_awaddr),
		.i_awid(if1.i_awid),
		.i_awlen(if1.i_awlen),
		.i_awvalid(if1.i_awvalid),
		.o_awready(if1.o_awready),
		.i_wdata(if1.i_wdata),
		.i_wid(if1.i_wid),
		.i_wstrb(if1.i_wstrb),
		.i_wlast(if1.i_wlast),
		.i_wvalid(if1.i_wvalid),
		.o_wready(if1.o_wready),
		.o_bresp(if1.o_bresp),
		.o_bid(if1.o_bid),
		.o_bvalid(if1.o_bvalid),
		.i_bready(if1.i_bready),
		.i_araddr(if1.i_araddr),
		.i_arid(if1.i_arid),
		.i_arlen(if1.i_arlen),
		.i_arvalid(if1.i_arvalid),
		.o_arready(if1.o_arready),
		.o_rdata(if1.o_rdata),
		.o_rid(if1.o_rid),
		.o_rresp(if1.o_rresp),
		.o_rlast(if1.o_rlast),
		.o_rvalid(if1.o_rvalid),
		  .i_rready(if1.i_rready));
   
   

   
endmodule // top



module axi_slave
#(
parameter	AXI_ID_WIDTH = 4
)
(
	 	clk,
		rstn,

		// AXI write address channel
		i_awaddr,
		i_awid,
		i_awlen,
		i_awvalid,
		o_awready,

		// AXI write data channel
		i_wdata,
		i_wid,
		i_wstrb,
		i_wlast,
		i_wvalid,
		o_wready,
		o_bresp,
		o_bid,
		o_bvalid,
		i_bready,

		// AXI read address channel
		i_araddr,
		i_arid,
		i_arlen,
		i_arvalid,
		o_arready,

		// AXI read data channel
		o_rdata,
		o_rid,
		o_rresp,
		o_rlast,
		o_rvalid,
		i_rready
);

input           clk;
input           rstn;

// AXI write address channel
input   [31:0]  i_awaddr;
input   [AXI_ID_WIDTH-1:0]   i_awid;
input   [3:0]   i_awlen;
input           i_awvalid;
output          o_awready;

// AXI write data channel
input   [31:0]  i_wdata;
input   [AXI_ID_WIDTH-1:0]   i_wid;
input   [3:0]   i_wstrb;
input           i_wlast;
input           i_wvalid;
output          o_wready;
output  [AXI_ID_WIDTH-1:0]   o_bid;
output  [1:0]   o_bresp;
output          o_bvalid;
input           i_bready;

// AXI read address channel
input   [31:0]  i_araddr;
input   [AXI_ID_WIDTH-1:0]   i_arid;
input   [3:0]   i_arlen;
input           i_arvalid;
output          o_arready;

// AXI read data channel
output  [31:0]  o_rdata;
output  [AXI_ID_WIDTH-1:0]   o_rid;
output  [1:0]   o_rresp;
output          o_rlast;
output          o_rvalid;
input           i_rready;

parameter      ST_R_IDLE = 3'd0;
parameter      ST_R_PRE1 = 3'd1;
parameter      ST_R_PRE2 = 3'd2;
parameter      ST_R_PRE3 = 3'd3;
parameter      ST_R_READ = 3'd4;
parameter      ST_R_END  = 3'd5;

parameter      ST_W_IDLE  = 3'd0;
parameter      ST_W_PRE1  = 3'd1;
parameter      ST_W_PRE2  = 3'd2;
parameter      ST_W_PRE3  = 3'd3;
parameter      ST_W_WRITE = 3'd4;
parameter      ST_W_END   = 3'd5;

reg     [2:0]  r_cs;
reg     [2:0]  r_ns;
reg     [2:0]  w_cs;
reg     [2:0]  w_ns;

reg     [3:0]  rdcnt;
reg     [31:0] araddr;
reg     [3:0]  arlen;
reg     [AXI_ID_WIDTH-1:0]  arid;

reg     [3:0]  wdcnt;
reg     [31:0] awaddr;
reg     [3:0]  awlen;
reg     [AXI_ID_WIDTH-1:0]  awid;

reg     [5:0]  axi_wait_cnt_0;
reg     [5:0]  axi_wait_cnt_1;
reg     [5:0]  axi_wait_num_0;
reg     [5:0]  axi_wait_num_1;
reg     [31:0] rdn_num_0;
reg     [31:0] rdn_num_1;

reg     [31:0]  o_rdata;
reg     [31:0]  mem[63:0];

initial begin
	//$mem_alloc();
end


   
 initial $monitor("%t o_awready = %b, i_awvalid = %b, rstn=%b, i_wvalid=%b, o_wready=%b, i_wdata=%b, o_bresp=%b, o_bid=%d, o_bvalid=%b, awlen=%d , wdcnt=%d, i_wlast= %b",$time, o_awready, i_awvalid,rstn, i_wvalid, o_wready, i_wdata, o_bresp, o_bid, o_bvalid, awlen, wdcnt, i_wlast);
   
always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		rdn_num_0 <= 32'd0;
		rdn_num_1 <= 32'd0;
	end else begin
		rdn_num_0 <= $random;
		rdn_num_1 <= $random;
	end
end

always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		axi_wait_cnt_0 <= 6'd0;
		axi_wait_num_0 <= 6'd8;
	end else if (i_arvalid & o_arready) begin
		axi_wait_cnt_0 <= 6'd0;
		axi_wait_num_0 <= rdn_num_0[5:0];
	end else if (i_arvalid & !o_arready) begin
		if (axi_wait_cnt_0==axi_wait_num_0) begin
			axi_wait_cnt_0 <= 5'd0;
		end else begin
			axi_wait_cnt_0 <= axi_wait_cnt_0 + 1'b1;
		end
	end
end

always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		axi_wait_cnt_1 <= 6'd0;
		axi_wait_num_1 <= 6'd8;
	end else if (i_awvalid & o_awready) begin
		axi_wait_cnt_1 <= 6'd0;
		axi_wait_num_1 <= rdn_num_1[5:0];
	end else if (i_awvalid & !o_awready) begin
		if (axi_wait_cnt_1==axi_wait_num_1) begin
			axi_wait_cnt_1 <= 5'd0;
		end else begin
			axi_wait_cnt_1 <= axi_wait_cnt_1 + 1'b1;
		end
	end
end

//------------------------------------------------------------------------------------------------
`ifdef AXI_BUSY
assign o_arready = (r_cs==ST_R_IDLE) & (axi_wait_cnt_0==axi_wait_num_0);
`else
assign o_arready = (r_cs==ST_R_IDLE);
`endif

assign o_rresp   = 2'b00;
assign o_rvalid  = (r_cs==ST_R_READ);
assign o_rlast   = o_rvalid & (rdcnt==arlen);
assign o_rid     = arid;

always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		r_cs <= ST_R_IDLE;
	end else begin
		r_cs <= r_ns;
	end
end

always@(*) begin

	r_ns = r_cs;

	case (r_cs)
		ST_R_IDLE : r_ns = (i_arvalid & o_arready) ? ST_R_PRE1 : r_cs;
		ST_R_PRE1 : r_ns = ST_R_PRE2;
		ST_R_PRE2 : r_ns = ST_R_PRE3;
		ST_R_PRE3 : r_ns = ST_R_READ;
		ST_R_READ : r_ns = (o_rvalid & i_rready & rdcnt==arlen) ? ST_R_END : r_cs;
		ST_R_END  : r_ns = ST_R_IDLE;
	endcase
end


always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		rdcnt <= 4'd0;
	end else if (o_rvalid & i_rready) begin
		if (rdcnt==arlen) begin
			rdcnt <= 4'd0;
		end else begin
			rdcnt <= rdcnt + 1'b1;
		end
	end
end

always@(posedge clk) begin
	if (i_arvalid & o_arready) begin
		araddr <= i_araddr;
    arlen  <= i_arlen;
		arid   <= i_arid;
	end
end

always@(posedge clk) begin
	if ((r_cs==ST_R_PRE3) || (r_cs==ST_R_READ)) begin
		//mem_read(araddr,o_rdata);
	   mem_read;
	   araddr <= araddr + 4;
	end
end

//------------------------------------------------------------------------------------------------
always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		w_cs <= ST_W_IDLE;
	end else begin
		w_cs <= w_ns;
	end
end

always@(*) begin

	w_ns = w_cs;

	case (w_cs)
		ST_W_IDLE  : w_ns = (i_awvalid & o_awready) ? ST_W_PRE1 : w_cs;
		ST_W_PRE1  : w_ns = ST_W_PRE2;
		ST_W_PRE2  : w_ns = ST_W_PRE3;
		ST_W_PRE3  : w_ns = ST_W_WRITE;
		ST_W_WRITE : w_ns = (i_wvalid & o_wready & wdcnt==awlen) ? ST_W_END : w_cs;
		ST_W_END   : w_ns = (o_bvalid & i_bready) ? ST_W_IDLE : w_cs;
	endcase
end

always@(posedge clk or negedge rstn) begin
	if (!rstn) begin
		wdcnt <= 4'd0;
	end else if (i_wvalid & o_wready) begin
		if (wdcnt==awlen) begin
			wdcnt <= 4'd0;
		end else begin
			wdcnt <= wdcnt + 1'b1;
		end
	end
end

always@(posedge clk) begin
	if (i_awvalid & o_awready) begin
		awaddr <= i_awaddr;
    awlen  <= i_awlen;;
		awid   <= i_awid;
	end
end

always@(posedge clk) begin
  integer t;
	if (i_wvalid & o_wready) begin
	   //		mem_write(awaddr,i_wstrb,i_wdata);
	   mem_write();
	   awaddr <= awaddr + 4;
	end
end

// for error checking
always@(posedge clk) begin
	if (i_wvalid & o_wready) begin
		if (wdcnt==awlen & !i_wlast) begin
			$display("[FAIL]: awlen does not match with wlast");
			$finish;
		end
		if (wdcnt!=awlen & i_wlast) begin
			$display("[FAIL]: awlen does not match with wlast");
			$finish;
		end
	end
end

`ifdef AXI_BUSY
assign o_awready = (w_cs==ST_W_IDLE) & (axi_wait_cnt_1==axi_wait_num_1);
`else
assign o_awready = (w_cs==ST_W_IDLE);
`endif

assign o_wready  = (w_cs==ST_W_WRITE);
assign o_bresp   = 2'b00;
assign o_bid     = awid;
assign o_bvalid  = (w_cs==ST_W_END);

///----------Memmory

   reg [31:0] mem [0:15];

   ///---------Read
   task mem_read();
      begin
	 o_rdata = mem[awaddr];
      end
   endtask //

///--------Write
   task mem_write();
      begin
	 mem[araddr] = o_rdata;
      end
   endtask //
   
   

   
endmodule


program test;

//Not using cb   virtual axi_slave_if vif;
      virtual axi_slave_if.TEST vif;
   virtual    axi_slave_if vif_d;
   
   //initial vif = top.if1;
  
   
   initial begin
      $display("Pass handle to virtual interface");

//NOTES: Get handle to Interface
//vif = top.if1;      
vif = top.if1.TEST;      
      vif_d = top.if1;
      
#10;
//Without cb      $display("Initialize the interface");
//Without cb      
//Without cb      vif.rstn <= 1'b0;
//Without cb      vif.i_awvalid <= 1'b0;
//Without cb      
//Without cb      repeat (2) @(posedge top.clk);
//Without cb      $display("Dassert reset");
//Without cb      
//Without cb      vif.rstn <= 1'b1;
//Without cb      repeat (2) @(posedge top.clk);
//Without cb      //Write;
//Without cb      $display("Start Write addr phase");
//Without cb      
//Without cb      vif.i_awaddr <= 32'd0;
//Without cb      vif.i_awid <= 4'd5;
//Without cb      vif.i_awlen <= 4'd3;
//Without cb      vif.i_awvalid <= 1'b1;
//Without cb
//Without cb      //`clkedge
//Without cb      @(posedge top.clk);
//Without cb      
//Without cb	$display("Waiting for slave to get ready");
//Without cb      
//Without cb//	wait(vif.o_awready);
//Without cb      $display("%t, Slave is ready",$time);
//Without cb      vif.i_awvalid <= 1'b0;
//Without cb
//Without cb      $display($time);
//Without cb      
//Without cb      repeat(2) @(posedge top.clk);
//Without cb      $display("Start Write data phase");
//Without cb      vif.i_wdata <= $random;
//Without cb      vif.i_wid <= 4'd5;
//Without cb      vif.i_wvalid <= 1'b1;
//Without cb      vif.i_wlast <= 1'b0;
//Without cb      wait (vif.o_wready);
//Without cb       $display("%t Sending DW1=%h", $time, vif.i_wdata);
//Without cb      @(posedge top.clk);
//Without cb      
//Without cb      vif.i_wdata <= $random;
//Without cb      vif.i_wid <= 4'd5;
//Without cb      vif.i_wvalid <= 1'b1;
//Without cb      wait(vif.o_wready);
//Without cb       $display("%t Sending DW2=%h", $time, vif.i_wdata);
//Without cb      @(posedge top.clk);
//Without cb      
//Without cb      vif.i_wdata <= $random;
//Without cb      vif.i_wid <= 4'd5;
//Without cb      vif.i_wvalid <= 1'b1;
//Without cb      //vif.i_wlast <= 1'b1;
//Without cb      wait(vif.o_wready);
//Without cb      $display("%t Sending DW3=%h", $time, vif.i_wdata);
//Without cb       @(posedge top.clk);
//Without cb      
//Without cb      vif.i_wvalid <= 1'b0;
//Without cb      vif.i_wlast <= 1'b1;
//Without cb       @(posedge top.clk);
//Without cb      vif.i_wlast <= 1'b0;
//Without cb      repeat (100) @(posedge top.clk);
//Without cb
      
//Using clocking block
            $display("Initialize the interface");

      @vif.cb;
//NOTES:: reset DUT and drive inputs to known state.      
      vif.rstn <= 1'b0;
      vif.cb.i_awvalid <= 1'b0;
//NOTES::Display value on the output ports      
      repeat (2) @vif.cb;
      $display("Dassert reset");
//NOTES:: Dassert RESET. Display output ports of DUT.      
      vif.rstn <= 1'b1;
      repeat (2) @vif.cb;
      //Write;
      $display("Start Write addr phase");
      
      vif.cb.i_awaddr <= 32'd0;
      vif.cb.i_awid <= 4'd5;
      vif.cb.i_awlen <= 4'd3;
      vif.cb.i_awvalid <= 1'b1;

      //`clkedge
      @vif.cb;
      
	$display("Waiting for slave to get ready");
      
//	wait(vif.cb.o_awready);
      $display("%t, Slave is ready",$time);
      vif.cb.i_awvalid <= 1'b0;

      $display($time);
      
      repeat(2) @vif.cb;
      $display("Start Write data phase");

      
      vif.cb.i_wdata <= $random;
      vif.cb.i_wid <= 4'd5;
      vif.cb.i_wvalid <= 1'b1;
      vif.cb.i_wlast <= 1'b0;
      wait (top.DUT.o_wready);
       $display("%t Sending DW1=%h", $time, vif_d.i_wdata);
      @vif.cb;
      
      vif.cb.i_wdata <= $random;
      vif.cb.i_wid <= 4'd5;
      vif.cb.i_wvalid <= 1'b1;
      wait(top.DUT.o_wready);
       $display("%t Sending DW2=%h", $time, vif_d.i_wdata);
      @vif.cb;
      
      vif.cb.i_wdata <= $random;
      vif.cb.i_wid <= 4'd5;
      vif.cb.i_wvalid <= 1'b1;
      //vif.cb.i_wlast <= 1'b1;
      wait(top.DUT.o_wready);
      $display("%t Sending DW3=%h", $time, vif_d.i_wdata);
       @vif.cb;
      
      vif.cb.i_wvalid <= 1'b0;
      vif.cb.i_wlast <= 1'b1;
       @vif.cb;
      vif.cb.i_wlast <= 1'b0;
      repeat (100) @vif.cb;
      
      
    end


   
   
      //Write response phase
  
      
      //Read;
  
endprogram // test

   
