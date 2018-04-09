
class test;
  
  static test me = get();
  
  static function test get();
    get = new();
  endfunction
  
  function new ();
    $display("This is singleton object");
  endfunction
  
  
endclass

program top;
  
endprogram

