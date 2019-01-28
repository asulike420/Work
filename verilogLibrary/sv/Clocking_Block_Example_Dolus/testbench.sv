module COUNTER (input Clock, Reset, Enable, Load, UpDn,
                input [7:0] Data, output reg[7:0] Q);
  always @(posedge Clock or posedge Reset)
    if (Reset)
      Q <= 0;
    else
      if (Enable)
        if (Load)
          Q <= Data;
        else
          if (UpDn)
            Q <= Q + 1;
          else
            Q <= Q - 1;
endmodule
 



// Test program
program test_COUNTER(input Clock, Q,  output reg Reset, Enable, Load, UpDn, output reg [7:0] Data);
    // SystemVerilog "clocking block"
    // Clocking outputs are DUT inputs and vice versa
    default clocking cb_counter @(posedge Clock);
      default input #1step output #4;
      output negedge Reset;
      output Enable, Load, UpDn, Data;
      input Q;
    endclocking

    // Apply the test stimulus
    initial begin

      // Set all inputs at the beginning    
      Enable = 0;            
      Load = 0;
      UpDn = 1;
      Reset = 1;

      // Will be applied on negedge of clock!
      ##1 cb_counter.Reset  <= 0;
      // Will be applied 4ns after the clock!
      ##1 cb_counter.Enable <= 1;
      ##2 cb_counter.UpDn   <= 0;
      ##4 cb_counter.UpDn   <= 1;
      // etc. ...      
    end

    // Check the results - could combine with stimulus block
    initial begin
      ##1   
      // Sampled 1ps (or whatever the precision is) before posedge clock
      ##1 assert (cb_counter.Q == 8'b00000000);
      ##1 assert (cb_counter.Q == 8'b00000000);
      ##2 assert (cb_counter.Q == 8'b00000010);
      ##4 assert (cb_counter.Q == 8'b11111110);
      // etc. ...      
     end

    // Simulation stops automatically when both initials have been completed

  endprogram

 



module Test_Counter_w_clocking;
  timeunit 1ns;

  reg Clock = 0, Reset, Enable, Load, UpDn;
  reg [7:0] Data;
  wire [7:0] Q;

  // Clock generator
  always
  begin
    #5 Clock = 1;
    #5 Clock = 0;
  end

  
   // Instance the counter
  COUNTER G1 (Clock, Reset, Enable, Load, UpDn, Data, Q);

  // Instance the test program - not required, because program will be
  // instanced implicitly.
  test_COUNTER T1 (Clock, Q, Reset, Enable, Load, UpDn, Data);
  
endmodule

  
  
