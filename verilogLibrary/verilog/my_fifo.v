module my_fifo(
	       //Read
	       input		       rd_en,
	       input		       rd_clk,
	       output [DATA_WIDTH-1:0] rd_data,
	       output		       almost_empty,
	       output		       empty,
	       //Write
	       input		       wr_en,
	       input		       wr_clk,
	       input [DATA_WIDTH-1:0]  wr_data,
	       output		       almost_full,
	       output		       full,
	       //reset
	       input		       reset
	       );

   reg [DATA_WIDTH-1:0]		       mem [FIFO_DEPTH];
   enum				       reg [3:0] { 
						   RD_IDLE,
						   EMPTY,
						   ALMOST_EMPTY,
						   READ
						   }	rd_states;
   enum				       reg [3:0] { 
						   FULL,
						   ALMOST_FULL,
						   WRITE
						   }	wr_states;


   rd_states rd_st, rd_st_nxt;
   
   always @(posedge rd_clk) begin
      if(reset) begin
	 rd_st <= RD_IDLE;
	 almost_almost <= 0;
	 empty <= 1;
      end
      else begin
	 rd_st <= rd_st_nxt;
	 almost_empty <= almost_empty_nxt;
	 empty <= empty_nxt;
      end
   end // always @ (posedge rd_clk)

   always @(*) begin
      case(rd_st)
	RD_IDLE: begin
	   if(rd_en) begin
	      rd_st_nxt = READ;
	   else
	     rd_st_nxt = RD_IDLE;
	   end
	end
	READ: begin
	   rd_data_nxt = mem[rd_ptr];
	   if(rd_ptr == FIFO_DEPTH-1)
	     rd_ptr_nxt = 0;
	   else
	     rd_ptr_nxt = rd_ptr + 1;

	   if(rd_en) begin
	      rd_st_nxt = READ;
	   end
	   
	   if(
	      (rd_ptr_nxt == FIFO_DEPTH-1 && wr_ptr == 0)
	      ||
	      (rd_ptr_nxt == wr_ptr -1)
	      )
	     begin
		almost_empty_nxt = 1;
		rd_st_nxt = ALMOST_EMPTY;
	     end
	end
	ALMOST_EMPTY: begin
	   
	end
	EMPTY: begin

	end
      endcase // case (rd_st)
   end
   
endmodule


