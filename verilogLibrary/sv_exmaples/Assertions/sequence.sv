    e<=1;ack <=1;
    #100 $finish();
  end
  
  initial
    begin
      $dumpfile("wave.vcd");
      $dumpvars;
    end
  
  
endmodule
