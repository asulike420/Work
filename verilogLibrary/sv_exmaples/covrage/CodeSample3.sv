program main;
bit [0:3] y;
bit [0:2] values[$]= '{3,5,6};

covergroup cg;
cover_point_y : coverpoint y {
bins tran_34 = (3=>4);
bins tran_56 = (5=>6);
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

