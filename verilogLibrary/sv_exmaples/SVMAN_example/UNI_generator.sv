class UNI_generator;
  UNI_cell blueprint; // Blueprint for generator
  mailbox  gen2drv;   // Mailbox to driver for cells
event    drv2gen;
int      nCells;
int      PortID;
// Event from driver when done with cell
// Num cells for this generator to create
// Which Rx port are we generating?
  function new(input mailbox gen2drv,
               input event drv2gen,
               input int nCells, PortID);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;
    this.nCells  = nCells;
    this.PortID  = PortID;
    blueprint = new();
  endfunction : new
  task run();
    UNI_cell cell;
    repeat (nCells) begin
      assert(blueprint.randomize());
      $cast(cell, blueprint.copy());
      cell.display($psprintf("@%0t: Gen%0d: ", $time, PortID));
      gen2drv.put(cell);
      @drv2gen;// Wait for driver to finish with it
    end
  endtask : run
endclass : UNI_generator