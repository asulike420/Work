class packet;
  typedef enum {WRITE, READ, ATOMIC} cmdType;
  typedef enum {IN_VPR_L, OUT_VPR_L, IN_VPR_P, OUT_VPR_P} addrType;
  typedef enum {TRUSTED, UNTRUSTED, QUARANTINE, GRAPHICS} trustLevel;
  rand addrType addr;
  rand cmdType cmd;
  rand trustLevel trust;
  
endclass


program test;
 
  packet pkt;
  
  covergroup cg (ref packet pkt);
  ADDR: coverpoint pkt.addr{option.weight = 0;}
  CMD:coverpoint pkt.cmd{option.weight = 0;}
  TRUST:coverpoint pkt.trust{option.weight = 0;}
    cross ADDR, CMD, TRUST{option.weight = 0;}
endgroup
  cg cg1;
  
  initial begin
    pkt = new();
   
    cg1 = new(pkt);
    repeat (10) begin
      pkt.randomize();
      cg1.sample();
    end
  end
  
endprogram
