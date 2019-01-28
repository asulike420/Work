program automatic test;
import uvm_pkg::*;

`include "test_collection.sv"

initial begin
  $timeformat(-9, 1, "ns", 10);

  //
  // The following statement enables RAL coverage.
  //
  uvm_reg::include_coverage("*", UVM_CVR_ALL);

  run_test();
end

endprogram

