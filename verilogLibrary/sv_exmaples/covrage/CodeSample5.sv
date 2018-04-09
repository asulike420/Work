program main;
bit [0:2] y;
bit [0:2] values[$]= '{1,6,3,7,3,4,3,5};

covergroup cg;
cover_point_y : coverpoint y {
ignore_bins ig = {1,2,3,4,5};
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

