program automatic test;

class base;
  string name;
  function new(string name);
    this.name = name;
  endfunction
  virtual function string get_name();
    return(this.name);
  endfunction
  virtual function string get_typename();
  endfunction
  virtual function void print();
    $display("name = %s", this.name);
  endfunction
endclass

virtual class proxy_base;
  virtual function base create_object(string name);
    return null;
  endfunction
  pure virtual function string get_typename();
endclass

typedef class factory;

class proxy_class #(type T=base, string Tname="<unknown>") extends proxy_base;
  typedef proxy_class#(T, Tname) this_type;
  static string type_name = Tname;
  static this_type me = get();

  static function this_type get();
    factory f = factory::get();
    if (me == null)  me = new();  
    f.register(me);
    return me;
  endfunction

  virtual function string get_typename();
    return (type_name);
  endfunction

  static function T create(string name);
    factory f = factory::get();
    $cast(create, f.create_object_by_type(me, name));
$display("Factory return %s", create.get_typename());
  endfunction
  virtual function base create_object(string name);
    T object_represented = new(name);
    return object_represented;
  endfunction
endclass

class myclass extends base;
  typedef proxy_class#(myclass, "myclass") proxy;
  function string get_typename();
    return proxy::type_name;
  endfunction
  function new(string name);
    super.new(name);
  endfunction
endclass

class anotherclass extends base;
  typedef proxy_class#(anotherclass, "anotherclass") proxy;
  function string get_typename();
    return proxy::type_name;
  endfunction
  function new(string name);
    super.new(name);
  endfunction
endclass

class mytestbench extends base;
  myclass m_obj;
  anotherclass a_obj;
  function new(string name);
    super.new(name);
    m_obj = myclass::proxy::create("m_obj");
    a_obj = anotherclass::proxy::create("a_obj");
  endfunction
  task run_test();
    $display("m_obj: type = %s, name = %s", m_obj.get_typename(), m_obj.get_name());
    $display("a_obj: type = %s, name = %s", a_obj.get_typename(), a_obj.get_name());
  endtask
endclass

class factory;
  // The registry array is not needed in this example
  static proxy_base registry[string];
  static string override[string];
  static factory me = get();
  static function factory get();
    if (me == null) me = new(); return me;
  endfunction

  function void register(proxy_base proxy);
$display("Registering %s", proxy.get_typename());
    registry[proxy.get_typename()] = proxy;
  endfunction

  function base create_object_by_type(proxy_base proxy, string name);
    base temp;
    proxy = find_override(proxy);
$display("Creating %s", proxy.get_typename());
    temp = proxy.create_object(name);
$display("Created %s", temp.get_typename());
    return proxy.create_object(name);
  endfunction

  static function void override_type(string type_name, override_type_name);
    override[type_name] = override_type_name;
foreach(override[i])
  $display("override[%s] = %s", i, override[i]);
  endfunction

  function proxy_base find_override(proxy_base proxy);
foreach(override[i])
  $display("override[%s] = %s", i, override[i]);

$display("Looking for overrides of %s", proxy.get_typename());
    if (override.exists(proxy.get_typename())) begin
$display("Found override for %s", proxy.get_typename());
$display("The override is %s", override[proxy.get_typename()]);
      return registry[override[proxy.get_typename()]];
    end
    return proxy;
  endfunction
endclass

class modified_myclass extends myclass;
  typedef proxy_class#(modified_myclass, "modified_myclass") proxy;
  function string get_typename();
    return proxy::type_name;
  endfunction
  function new(string name);
    super.new(name);
  endfunction
endclass

initial begin
  mytestbench t;
  factory::override_type("myclass", "modified_myclass");
  t = new("t");
  $timeformat(-9, 1, "ns", 10);
  t.run_test();
end

endprogram
