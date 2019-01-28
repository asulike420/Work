program main;
reg [0:3] y;
reg [0:3] values[$]= '{ 4'b1100,4'b1101,4'b1110,4'b1111};

covergroup cg;
cover_point_y : coverpoint y {
wildcard bins g12_15 = { 4'b11?? } ;
}

endgroup

cg cg_inst = new();
initial
foreach(values[i])
begin
y = values[i];
cg_inst.sample();
end

endprogram 
