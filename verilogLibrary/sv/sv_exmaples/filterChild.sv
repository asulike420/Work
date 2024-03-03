class b;
  reg xb;
endclass

class ch1 extends b;
  reg xc1;
endclass

class ch2 extends b;
  reg xc2;
endclass

program test;
  b bq[$];
  ch1 child1, child;
  ch1 child2;
  
  initial begin
    child1 = new();
    child2 =new ();
    bq.push_back(child1);
    bq.push_back(child2);
    bq.shuffle();
    foreach(bq[i])
	begin
      if($cast(child, bq[i]))
        $display($typename(bq[i]));
    end
  end	
endprogram
