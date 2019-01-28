
class Config;
  int nErrors, nWarnings;  // Number of errors, warnings
  bit [31:0] numRx, numTx; // Copy of parameters
  rand bit [31:0] nCells;  // Total cells
  constraint c_nCells_valid
     {nCells > 0; }
  constraint c_nCells_reasonable
     {nCells < 1000; }
  rand bit in_use_Rx[];     // Input / output channel enabled
  constraint c_in_use_valid
    {in_use_Rx.sum > 0; }   // At least one RX is enabled
  rand bit [31:0] cells_per_chan[];
  constraint c_sum_ncells_sum  // Split cells over all channels
    {cells_per_chan.sum == nCells;}    // Total number of cells
  // Set the cell count to zero for any channel not in use
  constraint zero_unused_channels
    {foreach (cells_per_chan[i])
      {
       // Needed for even dist of in_use
       solve in_use_Rx[i] before cells_per_chan[i];
       if (in_use_Rx[i])
         cells_per_chan[i] inside {[1:nCells]};
         else cells_per_chan[i] == 0;
       }
}
  extern function new(input bit [31:0] numRx, numTx);
  extern virtual function void display(input string prefix="");
endclass : Config


function Config::new(input bit [31:0] numRx, numTx);
  this.numRx = numRx;
  in_use_Rx = new[numRx];
  this.numTx = numTx;
  cells_per_chan = new[numRx];
endfunction : new



function void Config::display(input string prefix);
  $write("%sConfig: numRx=%0d, numRx=%0d, nCells=%0d (",
          prefix, numRx, numRx, nCells);
  foreach (cells_per_chan[i])
    $write("%0d ", cells_per_chan[i]);
  $write("), enabled RX: ", prefix);
  foreach (in_use_Rx[i]) if (in_use_Rx[i]) $write("%0d ", i);
  $display;
 endfunction : display