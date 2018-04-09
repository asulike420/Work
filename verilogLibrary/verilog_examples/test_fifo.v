
program testFifo;


logic clk      , // Clock input
logic rst      , // Active high reset
logic wr_cs    , // Write chip select
logic rd_cs    , // Read chipe select
logic [7:0]data_in  , // Data input
logic rd_en    , // Read enable
logic wr_en    , // Write Enable
logic [7:0]data_out , // Data Output
logic empty    , // FIFO empty
logic full   
   
syn_fifo DUT #(ADDR_WIDTH = 4)(
.clk(clk)      , // Clock input
.rst(rst)      , // Active high reset
.wr_cs(wr_cs)    , // Write chip select
.rd_cs(rd_cs)    , // Read chipe select
.data_in(data_in)  , // Data input
.rd_en(rd_en)    , // Read enable
.wr_en(wr_en)    , // Write Enable
.data_out(data_out) , // Data Output
.empty(empty)    , // FIFO empty
.full(full)  
	     );

//Clock
   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   
   

//Chip Initiallization
   initial begin
      rst = 0;
      wr_cs = 0;
      wr_en = 0;
      rd_cs = 0;
      rd_en = 0;
      @(posedge clk);
      rst = 1;
      @(posedge clk)
	rst = 0;
      wr_cs = 1;
      rd_cs = 1;
      @(posedge clk);
      
  
	fork
	   begin
	      repeat(10) write();
   
	   end

	   begin
	      @(posedge clk);
	      repeat(10) read();
	   end
end
   

   
//Write


//Read

   

   
   
//task write

   task write ();
      //wait(!full);
      wr_en = 1'b1;
      data_in = $urandom();
      @(posedge clk)
	wr_en = 1'b0;
   endtask // write
   


//task read
   task read();

      rd_en = 1'b0;
      @(posedge clk);
      rd_en = 1'b1;

   endtask // read
   


endprogram // testFifo
   
