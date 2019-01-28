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

endinterface // axi_slave_if



module top;


   reg clk;
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

