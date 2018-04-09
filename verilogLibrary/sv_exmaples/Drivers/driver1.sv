
typedef class Driver_cbs;
class Driver;
mailbox gen2drv; event drv2gen; vUtopiaRx Rx;
// For cells sent from generator
// Tell generator when I am done with cell
 // Virtual ifc for transmitting cells
Driver_cbs cbsq[$]; // Queue of callback objects
int PortID;
  extern function new(input mailbox gen2drv,
                      input event drv2gen,
                      input vUtopiaRx Rx,
                      input int PortID);
  extern task run();
  extern task send (input UNI_cell cell);
endclass : Driver



// run(): Run the driver.
// Get transaction from generator, send into DUT
task Driver::run();
  UNI_cell cell;
  bit drop = 0;
  // Initialize ports
  Rx.cbr.data  <= 0;
  Rx.cbr.soc   <= 0;
  Rx.cbr.clav  <= 0;
  forever begin
    // Read the cell at the front of the mailbox
    gen2drv.peek(cell);
    begin: Tx
      // Pre-transmit callbacks
      foreach (cbsq[i]) begin
        cbsq[i].pre_tx(this, cell, drop);
        if (drop) disable Tx; // Don't transmit this cell
      end
    cell.display($psprintf("@%0t: Drv%0d: ", $time, PortID));
    send(cell);
  // Post-transmit callbacks
    foreach (cbsq[i])
      cbsq[i].post_tx(this, cell);
    end : Tx
    gen2drv.get(cell);  // Remove cell from the mailbox
->drv2gen; // Tell the generator we are done with this cell end
endtask : run







task Driver::send(input UNI_cell cell);
  ATMCellType Pkt;
  cell.pack(Pkt);
  $write("Sending cell: ");
  foreach (Pkt.Mem[i])
  $write("%x ", Pkt.Mem[i]); $display;
  // Iterate thru bytes of cell
  @(Rx.cbr);
  Rx.cbr.clav <= 1;
  for (int i=0; i<=52; i++) begin
    // If not enabled, loop
    while (Rx.cbr.en === 1'b1) @(Rx.cbr);
    // Assert Start Of Cell, assert enable, send byte 0 (i==0)
    Rx.cbr.soc  <= (i == 0);
    Rx.cbr.data <= Pkt.Mem[i];
    @(Rx.cbr);
  end
  Rx.cbr.soc <= 'z;
  Rx.cbr.data <= 8'bx;
  Rx.cbr.clav <= 0;
endtask