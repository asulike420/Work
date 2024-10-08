   //-----------------------------------------------------
  // Design Name : ram_dp_ar_aw
  // File Name   : ram_dp_ar_aw.v
  // Function    : Asynchronous read write RAM
  // Coder       : Deepak Kumar Tala
  //-----------------------------------------------------
  module ram_dp_ar_aw (
  address_0 , // address_0 Input
  data_0    , // data_0 bi-directional
  cs_0      , // Chip Select
  we_0      , // Write Enable/Read Enable
  oe_0      , // Output Enable
  address_1 , // address_1 Input
  data_1    , // data_1 bi-directional
  cs_1      , // Chip Select
  we_1      , // Write Enable/Read Enable
  oe_1        // Output Enable
  ); 

  parameter DATA_WIDTH = 8 ;
  parameter ADDR_WIDTH = 8 ;
  parameter RAM_DEPTH = 1 << ADDR_WIDTH;

  //--------------Input Ports----------------------- 
  input [ADDR_WIDTH-1:0] address_0 ;
  input cs_0 ;
  input we_0 ;
  input oe_0 ; 
  input [ADDR_WIDTH-1:0] address_1 ;
  input cs_1 ;
  input we_1 ;
  input oe_1 ; 

  //--------------Inout Ports----------------------- 
  inout [DATA_WIDTH-1:0] data_0 ; 
  inout [DATA_WIDTH-1:0] data_1 ;

  //--------------Internal variables---------------- 
  reg [DATA_WIDTH-1:0] data_0_out ; 
  reg [DATA_WIDTH-1:0] data_1_out ;
  reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

  //--------------Code Starts Here------------------ 
  // Memory Write Block 
  // Write Operation : When we_0 = 1, cs_0 = 1
  always @ (address_0 or cs_0 or we_0 or data_0
  or address_1 or cs_1 or we_1 or data_1)
  begin : MEM_WRITE
    if ( cs_0 && we_0 ) begin
       mem[address_0] = data_0;
    end else if  (cs_1 && we_1) begin
       mem[address_1] = data_1;
    end
  end

  // Tri-State Buffer control 
  // output : When we_0 = 0, oe_0 = 1, cs_0 = 1
  assign data_0 = (cs_0 && oe_0 && !we_0) ? data_0_out : 8'bz; 

  // Memory Read Block 
  // Read Operation : When we_0 = 0, oe_0 = 1, cs_0 = 1
  always @ (address_0 or cs_0 or we_1 or oe_0)
  begin : MEM_READ_0
    if (cs_0 && !we_0 && oe_0) begin
      data_0_out = mem[address_0]; 
    end else begin
      data_0_out = 0; 
    end
  end 

  //Second Port of RAM
  // Tri-State Buffer control 
  // output : When we_0 = 0, oe_0 = 1, cs_0 = 1
  assign data_1 = (cs_1 && oe_1 && !we_1) ? data_1_out : 8'bz; 
  // Memory Read Block 1 
  // Read Operation : When we_1 = 0, oe_1 = 1, cs_1 = 1
  always @ (address_1 or cs_1 or we_1 or oe_1)
  begin : MEM_READ_1
    if (cs_1 && !we_1 && oe_1) begin
      data_1_out = mem[address_1]; 
    end else begin
      data_1_out = 0; 
    end
  end

  endmodule // End of Module ram_dp_ar_aw





  //-----------------------------------------------------
  // Design Name : syn_fifo
  // File Name   : syn_fifo.v
  // Function    : Synchronous (single clock) FIFO
  // Coder       : Deepak Kumar Tala
  //-----------------------------------------------------
  module syn_fifo (
  clk      , // Clock input
  rst      , // Active high reset
  wr_cs    , // Write chip select
  rd_cs    , // Read chipe select
  data_in  , // Data input
  rd_en    , // Read enable
  wr_en    , // Write Enable
  data_out , // Data Output
  empty    , // FIFO empty
  full       // FIFO full
  );    

  // FIFO constants
  parameter DATA_WIDTH = 8;
  parameter ADDR_WIDTH = 8;
  parameter RAM_DEPTH = (1 << ADDR_WIDTH);
  // Port Declarations
  input clk ;
  input rst ;
  input wr_cs ;
  input rd_cs ;
  input rd_en ;
  input wr_en ;
  input [DATA_WIDTH-1:0] data_in ;
  output full ;
  output empty ;
  output [DATA_WIDTH-1:0] data_out ;

  //-----------Internal variables-------------------
  reg [ADDR_WIDTH-1:0] wr_pointer;
  reg [ADDR_WIDTH-1:0] rd_pointer;
  reg [ADDR_WIDTH :0] status_cnt;
  reg [DATA_WIDTH-1:0] data_out ;
  wire [DATA_WIDTH-1:0] data_ram ;

  //-----------Variable assignments---------------
  assign full = (status_cnt == (RAM_DEPTH-1));
  assign empty = (status_cnt == 0);

  //-----------Code Start---------------------------
  always @ (posedge clk or posedge rst)
  begin : WRITE_POINTER
    if (rst) begin
      wr_pointer <= 0;
    end else if (wr_cs && wr_en ) begin
      wr_pointer <= wr_pointer + 1;
    end
  end
    initial   $monitor("%t rd_pointer=%d data_out=%d , data_ram=%d",$time, rd_pointer,data_out, data_ram);
   
   
  always @ (posedge clk or posedge rst)
  begin : READ_POINTER
    if (rst) begin
      rd_pointer <= 0;
    end else if (rd_cs && rd_en ) begin
      rd_pointer <= rd_pointer + 1;
    end
  end

  always  @ (posedge clk or posedge rst)
  begin : READ_DATA
    if (rst) begin
      data_out <= 0;
    end else if (rd_cs && rd_en ) begin
      data_out <= data_ram;
    end
  end

  always @ (posedge clk or posedge rst)
  begin : STATUS_COUNTER
    if (rst) begin
      status_cnt <= 0;
    // Read but no write.
    end else if ((rd_cs && rd_en) && !(wr_cs && wr_en) 
                  && (status_cnt != 0)) begin
      status_cnt <= status_cnt - 1;
    // Write but no read.
    end else if ((wr_cs && wr_en) && !(rd_cs && rd_en) 
                 && (status_cnt != RAM_DEPTH)) begin
      status_cnt <= status_cnt + 1;
    end
  end 

  ram_dp_ar_aw #(DATA_WIDTH,ADDR_WIDTH)DP_RAM (
  .address_0 (wr_pointer) , // address_0 input 
  .data_0    (data_in)    , // data_0 bi-directional
  .cs_0      (wr_cs)      , // chip select
  .we_0      (wr_en)      , // write enable
  .oe_0      (1'b0)       , // output enable
  .address_1 (rd_pointer) , // address_q input
  .data_1    (data_ram)   , // data_1 bi-directional
  .cs_1      (rd_cs)      , // chip select
  .we_1      (1'b0)       , // Read enable
  .oe_1      (rd_en)        // output enable
  );     

  endmodule



  //
  //program testFifo;
  module top;


  reg clk      ; // Clock input
  reg rst      ; // Active high reset
  reg wr_cs    ; // Write chip select
  reg rd_cs    ; // Read chipe select
  reg [7:0]data_in  ; // Data input
  reg rd_en    ; // Read enable
  reg wr_en    ; // Write Enable
  wire [7:0]data_out ; // Data Output
  wire empty    ; // FIFO empty
     wire full   ;


  syn_fifo #(8,4) DUT(
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


   //initial $monitor("%t Monitored Data=%d", $time, data_out);

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

        //automatic int count = 0;

      fork
         begin
           int count = 0;
           repeat(10) write(count);
           //$display("%t Writing",$time);
         end

         begin
             int count = 0;
           repeat (2)@(posedge clk);
           repeat(10) read(count);
         //$display("%t Reading",$time);
         end
      join

       $display("Threads execution over");
  end



  //Write


  //Read





  //task write

    task write (ref int count);
        //wait(!full);
        count++;

        wr_en = 1'b1;
        data_in = $urandom();
      

        @(posedge clk)
      $display("%t Write Count = %d Writing Data=%d ", $time, count, data_in);
      wr_en = 1'b0;


     endtask // write



  //task read
    task read(ref int count);
        count++;

        rd_en = 1'b1;
        @(posedge clk);
        rd_en = 1'b0;
      $display("%t Read Count=%d Data out =%d ", $time, count, data_out);


     endtask // read


  endmodule
  //endprogram // testFifo


  /////RESULT
  //                 125 Writing
  //                 135 Reading
  ///Since test is inside module and automatic variables are not used , the last tread executed value retains.

