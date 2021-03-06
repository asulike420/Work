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
  logic [31:0] addr;
  
  task sampleCoverage(Packet pkt);
    addr = pkt.addr;
    cg.sample();
  endtask
  
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
  logic [31:0] addr;
  
  covergroup cgInside(ref logic [31:0] addr);
   // option.get_inst_coverage = 1;
    coverpoint addr{
      bins a = {[2:4]};
      bins b = {1};
    
    }
  endgroup
  
   cgInside cgi; 
    
    
  int covered, total,covered_inst,total_inst;
  
  initial
    begin
      cgi = new(addr);
      pkt = new();
      cv = new();
      pkt.randomize();	
      cv.pkt = pkt;
      addr = pkt.addr;
  	  
      cv.cg.sample();
      //cv.sampleCoverage(pkt);
      cgi.sample();
      //cv.cg.get_coverage(covered, total);
      cv.cg.pkt.addr.get_inst_coverage(covered, total);
      cgi.addr.get_inst_coverage(covered_inst,total_inst);
      $display("covered =%d, total=%d, covered_inst=%d,total_inst=%d",covered, total,covered_inst,total_inst);
      $display("%p",pkt);
      
    end
  
endprogram
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////


  class Packet pkt;
  
    constraint con {
      // pkt.addr inside {1,2}; //[5:10]};
      pkt.data.size() inside {5,10};
      foreach (pkt.data[i]) {pkt.data[i] >= 4;
                             //pkt.data[i] >= 10;
                            }
}


program test();
  
  Transaction tr;
  int length;
  Packet pkt_q[$];
  logic [31:0] data_q[];
  int coverage, total;
  
  covergroup cg(ref logic [31:0] data);
    coverpoint data{
      bins a = {4};
      bins b = {2}; 
    
    }
  endgroup

  cg cgi[];
  
  initial
    begin
      tr = new();
      
      length = 0;
      repeat (8) begin
        assert(tr.randomize());
        if (length < tr.pkt.data.size ) length = tr.pkt.data.size ;
        pkt_q.push_back(tr.pkt);
      end
      
      cgi = new[length];
      data_q = new[length];
      foreach (cgi[i]) cgi[i] = new(data_q[i]);
      foreach (pkt_q[i]) begin
        for (int j = 0; j < pkt_q[i].data.size; j++) begin
          data_q[j] = pkt_q[i].data[j];
          cgi[j].sample();
          $display("%d %d pkt_q[i][j]=%d",i,j,pkt_q[i].data[j]);
        end
          
      end
      cg::data::get_coverage(coverage, total);
      $display("Coverage=%d, total= %d",coverage, total);
  
    end
  
  
  
  
  
  
endprogram 



