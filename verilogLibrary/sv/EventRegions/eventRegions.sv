//Event regions in System verilog.

module testRegions();

   wire contAssigned1, contAssigned2;

   reg 	procAssigned1, procAssigned2;
   
   assign contAssigned1 = procAssigned1;
   assign contAssigned2 = 1;
   
   initial
     begin
     procAssigned1 = 1;
	procAssigned2  = contAssigned2;
	
     end
   
   initial
     $display("contAssigned1=%b : procAssigned1=%b: procAssigned2=%b: contAssigned2=%b\n", contAssigned1, procAssigned1, procAssigned2, contAssigned2);
   
   


   endmodule
