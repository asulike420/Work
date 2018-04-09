program main;
bit [0:1] y;
bit [0:1] y_values[$]= '{1,3};

bit [0:1] z;
bit [0:1] z_values[$]= '{1,2};

covergroup cg;
cover_point_y : coverpoint y ;
cover_point_z : coverpoint z ;
cross_yz : cross cover_point_y,cover_point_z ;
endgroup

cg cg_inst = new();
initial
foreach(y_values[i])
begin
y = y_values[i];
z = z_values[i];
cg_inst.sample();
end

endprogram 
