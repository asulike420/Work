
   module add_1 (/*AUTOARG*/
   // Outputs
   b,
   // Inputs
   we_1, we_0, oe_1, oe_0, cs_1, cs_0, address_1, address_0, a, c
   ) ;
   input  a;
   output b;
   input  c;

/*AUTOINPUT*/
// Beginning of automatic inputs (from unused autoinst inputs)
input [ADDR_WIDTH-1:0]	address_0;		// To instName1 of ram_dp_ar_aw.v
input [ADDR_WIDTH-1:0]	address_1;		// To instName1 of ram_dp_ar_aw.v
input			cs_0;			// To instName1 of ram_dp_ar_aw.v
input			cs_1;			// To instName1 of ram_dp_ar_aw.v
input			oe_0;			// To instName1 of ram_dp_ar_aw.v
input			oe_1;			// To instName1 of ram_dp_ar_aw.v
input			we_0;			// To instName1 of ram_dp_ar_aw.v
input			we_1;			// To instName1 of ram_dp_ar_aw.v
// End of automatics
   /*AUTOOUTPUT*/
   
   
   check instName #(/*AUTOINSTPARAM*/) (/*AUTOINST*/
					// Outputs
					.b		(b),
					// Inputs
					.a		(a));


   ram_dp_ar_aw instName1 #(/*AUTOINSTPARAM*/
			    // Parameters
			    .DATA_WIDTH		(DATA_WIDTH),
			    .ADDR_WIDTH		(ADDR_WIDTH),
			    .RAM_DEPTH		(RAM_DEPTH))(/*AUTOINST*/
							     // Inouts
							     .data_0		(data_0[DATA_WIDTH-1:0]),
							     .data_1		(data_1[DATA_WIDTH-1:0]),
							     // Inputs
							     .address_0		(address_0[ADDR_WIDTH-1:0]),
							     .cs_0		(cs_0),
							     .we_0		(we_0),
							     .oe_0		(oe_0),
							     .address_1		(address_1[ADDR_WIDTH-1:0]),
							     .cs_1		(cs_1),
							     .we_1		(we_1),
							     .oe_1		(oe_1));
   
endmodule // abhas


module check(a,b)
   input a;

   output b;
   
   endmodule

 
endmodule // add_1


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
