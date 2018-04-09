program test;
  
  integer md[2][3] = '{'{1,2,3}, '{4,5,6}};
  
  initial 
    foreach(md[i,j])
      $display("md[%d,%d]=%d\n",i,j,md[i][j]);
    
  
endprogram
