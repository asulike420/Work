class Packet;
  
  rand logic [31:0] addr;
  rand logic [31:0] data;
  rand logic wren, rden;
  
  
  function void  pre_randomize();
    $display("Pre_randomizre");
  endfunction
    function void  post_randomize();
      $display("Post_randomizre");
    endfunction
  
  constraint RdWr {if(wren) rden==0;	 
                  else rden==1;}
  
  constraint addCon{ addr < 2; addr>0	;}
  constraint datacon { data < 5; data>0	;}
	  
endclass

class coverage;
  Packet pkt;
  
  function new();
    cg = new();
  endfunction 
  
  covergroup cg;
    coverpoint pkt.addr{
    
      bins a = {[0:5]};
      bins b = {10};
      }
  endgroup
  
endclass

program test;
  
  Packet pkt;
  coverage cv;
  int covered, total;
  initial
    begin
      pkt = new();
      cv = new();
      pkt.randomize();	
      cv.pkt = pkt;
      cv.cg.start();
      cv.cg.sample();
      cv.cg.stop();
      //cv.cg.get_coverage(covered, total);
      cv.cg.get_inst_coverage(covered, total);
      $display("covered =%d, total=%d",covered, total);
      
      $display("%p",pkt);
      
    end
  
endprogram
