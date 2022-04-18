//TODO: make sure that the transaction class allows deep clone.
//TODO: Use UVM Callbacks

//  Class: trans
class trans extends uvm_sequence_item;
    typedef trans this_type_t;
    `uvm_object_utils(trans);

    //  Group: Variables


    //  Group: Constraints


    //  Group: Functions

    //  Constructor: new
    function new(string name = "trans");
        super.new(name);
    endfunction: new

    //  Function: do_copy
    // extern function void do_copy(uvm_object rhs);
    //  Function: do_compare
    // extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    //  Function: convert2string
    // extern function string convert2string();
    //  Function: do_print
    // extern function void do_print(uvm_printer printer);
    //  Function: do_record
    // extern function void do_record(uvm_recorder recorder);
    //  Function: do_pack
    // extern function void do_pack();
    //  Function: do_unpack
    // extern function void do_unpack();
    
endclass: trans

class drv extends uvm_driver #(trans);

    `uvm_component_utils(drv)

    function new (string name = "drv", uvm_component parent);

        super.new(name, parent);

    endfunction

    function void build_phase (uvm_phase phase);
        `uvm_info("drv", "Inside build phase, checking without call to super.new()", OVM_LOW)
    endfunction

    task run_phase (uvm_phase phase);
        `uvm_info("drv", "Inside run phase, checking without call to super.new()", OVM_LOW)
    endtask

    
endclass 


class monitor extends uvm_monitor;
    
    `uvm_component_utils(montor)

    uvm_analysis_port  #(trans) mon_analysis_port;

    function new(string name = "monitor", parent);
        super.new(name, parent)
    endfunction //new()

    function void build_phase(uvm_phase phase);
           
        mon_analysis_port = uvm_analysis_port#(trans)::type_id::create("mon_analysis_port", this); 
        
    endfunction

endclass //monitor extends uvm_monitor


class agent extends uvm_agent;

    `uvm_component_utils(agent)
    uvm_sequncer#(trans) sequencer;
    drv driver;
    uvm_monitor#(trans) monitor;


    function new(string name = "env", uvm_component parent);
        super.new(name, parent);//Create UVM hierarchy, using parent handle
    endfunction 

    function void build_phase(uvm_phase phase);
        sequencer = uvm_sequncer#(trans)::type_id::create("sequencer", this);
        driver    = drv::type_id::create("driver", this);
        monitor = uvm_monitor#(trans)::type_id::create("monitor", this);
        `uvm_info(get_full_name(), "BUILD PHASE COMPLETE", UVM_LOW);
    endfunction


    function void connect_phase(uvm_phase phase);
        driver.sequence_item_port.connect(sequencer.seq_item_export); //Note: sequence_item_export
        `uvm_info(get_full_name(), "CONNECT PHASE COMPLETE", UVM_LOW);    
    endfunction




endclass 


class scoreboard extends uvm_scoreboard #(trans);

    `uvm_component_utils(scoreboard)

    //uvm_tlm_analysis_fifo #(apb_trans) mas_mon_fifo_h;
    //uvm_tlm_analysis_fifo #(apb_slv_trans) slv_mon_fifo_h;

    //Mutiple analysis port
    //`uvm_analysis_imp_decl(_port_a)
    //`uvm_analysis_imp_decl(_port_b)
    //uvm_analysis_imp_port_a #(transaction,component_b) analysis_imp_a; 
    //uvm_analysis_imp_port_b #(transaction,component_b) analysis_imp_b;

    //Single analysis port
    uvm_analysis_port#(trans, scoreboard) scb_ana_imp_port;

    function new (string name = "scoreboard", uvm_component parent);

        super.new(name, this);
        scb_ana_imp_port = new("scb_ana_imp_port", this);
    endfunction



endclass

class env extends uvm_env;

    `uvm_component_utils(env)

    agent agt;
    scoreboard scb;

    function new(string name = "env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase();
        agt = agent:type_id::create("agt", this);
        scb = scoreboard::type_id::create("scb", this);
        `uvm_info(get_full_name(), "CONNECT PHASE COMPLETE", UVM_LOW); 
    endfunction

    function void connect_phase(uvm_phase phase);
        agent.monitor.mon_analysis_port.connect(scb.scb_ana_imp_port);
    endfunction
    
endclass

