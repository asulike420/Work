# Makefile for UVM Lab3
rtl_path = ../../rtl
test = test_base
DUT = $(rtl_path)/router.sv $(rtl_path)/router_io.sv $(rtl_path)/ral/host_io.sv $(rtl_path)/reset_io.sv
HARNESS_TOP = $(rtl_path)/router_test_top.sv
TB_TOP = ./test.sv
UVM_HOME = ../../uvm-1.2
log = simv.log
verbosity = UVM_MEDIUM
uvm_ver = uvm-1.1
seed = 1
defines = UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
plus = 
option = UVM_TR_RECORD +UVM_LOG_RECORD
#option = UVM_OBJECTION_TRACE
tcl = packet.tcl

uvm-1.1: all

all: simv run

simv compile: *.sv $(DUT) $(HARNESS_TOP) $(TB_TOP)
	vcs -sverilog -ntb_opts ${uvm_ver} -timescale="1ns/100ps" -l comp.log -debug_all +vcs+vcdpluson $(DUT) $(HARNESS_TOP) $(TB_TOP) +define+${defines}
	
run:
	./simv -l ${log} +ntb_random_seed=$(seed) +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(verbosity) +${plus} +${option} 

uvm-1.2: uvm_compile run

uvm_compile: *.sv
	vcs -sverilog ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS ${UVM_HOME}/src/uvm_pkg.sv +incdir+${UVM_HOME}/src+${VCS_HOME}/etc/uvm-1.1/vcs -timescale="1ns/100ps" -l comp.log -debug_all +vcs+vcdpluson $(DUT) $(HARNESS_TOP) $(TB_TOP) +define+${defines}

random: simv
	./simv -l ${log} +ntb_random_seed_automatic +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

dve:
	dve -vpd vcdplus.vpd -session $(tcl)&

dve_i: simv
	./simv -l ${log} -gui +ntb_random_seed=$(seed) +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

dve_tr:
	dve -vpd vcdplus.vpd &

solution: nuke
	cp ../../solutions/lab3/*.sv .
	cp ../../solutions/lab3/packet.tcl .

original: copy

copy: clean
	cp ../../solutions/lab2/*.sv .
	cp ../../solutions/lab3/driver.sv.orig driver.sv
	cp ../../solutions/lab3/test_collection.sv.orig test_collection.sv
	cp ../../solutions/lab3/router_env.sv.orig router_env.sv
	cp ../../solutions/lab3/reset_sequence.sv.orig reset_sequence.sv
	cp ../../solutions/lab3/packet_sequence.sv .
	cp ../../solutions/lab3/router_input_port_reset_sequence.sv .
	cp ../../solutions/lab3/input_agent.sv .
	cp ../../solutions/lab3/reset_agent.sv .
	cp ../../solutions/lab3/packet.tcl .

mycopy: nuke
	cp ../lab2/*.sv .
	cp ../../solutions/lab3/driver.sv.orig driver.sv
	cp ../../solutions/lab3/test_collection.sv.orig test_collection.sv
	cp ../../solutions/lab3/router_env.sv.orig router_env.sv
	cp ../../solutions/lab3/reset_sequence.sv.orig reset_sequence.sv
	cp ../../solutions/lab3/packet_sequence.sv .
	cp ../../solutions/lab3/router_input_port_reset_sequence.sv .
	cp ../../solutions/lab3/input_agent.sv .
	cp ../../solutions/lab3/reset_agent.sv .
	cp ../../solutions/lab3/packet.tcl .

clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys*

nuke: clean
	rm -rf *.sv *.tcl

help:
	@echo =======================================================================
	@echo  " 								       "
	@echo  " USAGE: make target <seed=xxx> <verbosity=YYY> <test=ZZZ>              "
	@echo  " 								       "
	@echo  "  xxx is the random seed.  Can be any integer except 0. Defaults to 1  "
	@echo  "  YYY sets the verbosity filter.  Defaults to UVM_MEDIUM               "
	@echo  "  ZZZ selects the uvm test.       Defaults to test_base                    "
	@echo  " 								       "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " all             => Compile TB and DUT files and run the simulation    "
	@echo  " compile         => Compile TB and DUT files                           "
	@echo  " run             => Run the simulation with seed                       "
	@echo  " random          => Run the simulation with random seed                "
	@echo  " dve             => Run DVE with preset waveform displayed             "
	@echo  " dve_i           => Run simulation interactively with DVE              "
	@echo  " dve_tr          => Run DVE with transaction debugging enabled         "
	@echo  "                                                                       "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help       => Displays this message                                   "
	@echo  " clean      => Remove all intermediate simv and log files              "
	@echo  " nuke       => Remove all source code and debug files                  "
	@echo  " original   => Return content of lab back to original state            "
	@echo  " copy       => Copy files from previous lab's solutions directory      "
	@echo  " mycopy     => Copy files from user's previous lab directory           "
	@echo  " solution   => Copy files from solutions directory for lab             "
	@echo  "								       "
	@echo  " ---------------------- EMBEDDED SETTINGS -----------------------------"
	@echo  " -timescale=\"1ns/100ps\"                                              "
	@echo  " -debug_all                                                            "
	@echo =======================================================================
