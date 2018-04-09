//
// The following virtual sequencer has been created for your in order to save
// lab time.
//
// A virtual sequencer typically only contains a list of sequencers needed
// to be managed by the virtual sequence.
//
// In this particular case, there are two sequencer types that need to be
// managed: reset_sequencer and packet_sequencer.  Within the DUT, there is
// only one reset_sequencer but multiple packet_sequencers.  Because of
// that, a queue of packet_sequencers is declared.
//

 
class virtual_reset_sequencer extends uvm_sequencer;
  `uvm_component_utils(virtual_reset_sequencer)

  typedef uvm_sequencer#(reset_tr) reset_sequencer;
  typedef uvm_sequencer#(packet) packet_sequencer;

  reset_sequencer  r_sqr;
  packet_sequencer pkt_sqr[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);    
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction: new
endclass: virtual_reset_sequencer

