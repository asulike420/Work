# Makefile for UVM Lab1
rtl_path = ../../rtl
TB_TOP = ./test.sv
UVM_HOME = ../../uvm-1.2
test = test_base
log = simv.log
verbosity = UVM_MEDIUM
uvm_ver = uvm-1.1
seed = 1
uvm_defines = UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
defines = UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR
plus = 
option = 
#option = UVM_OBJECTION_TRACE

uvm-1.1: all

all: simv run

simv compile: *.sv
	vcs -sverilog -ntb_opts ${uvm_ver} -timescale="1ns/100ps" -l comp.log -debug_all +vcs+vcdpluson $(DUT) $(HARNESS_TOP) $(TB_TOP) +define+${uvm_defines}+${defines}

run:
	./simv -l ${log} +ntb_random_seed=$(seed) +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

uvm-1.2: uvm_compile run

uvm_compile: *.sv
	vcs -sverilog ${UVM_HOME}/src/dpi/uvm_dpi.cc -CFLAGS -DVCS ${UVM_HOME}/src/uvm_pkg.sv +incdir+${UVM_HOME}/src+${VCS_HOME}/etc/uvm-1.1/vcs -timescale="1ns/100ps" -l comp.log -debug_all +vcs+vcdpluson $(DUT) $(HARNESS_TOP) $(TB_TOP) +define+${defines}

random: simv
	./simv -l ${log} +ntb_random_seed_automatic +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

dve_i: simv
	./simv -l ${log} -gui +ntb_random_seed=$(seed) +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(verbosity) +${plus} +${option}

environment:
	cp ../../solutions/lab1/packet.sv .
	cp ../../solutions/lab1/router_env.sv .
	cp ../../solutions/lab1/input_agent.sv .
	cp ../../solutions/lab1/driver.sv .

solution: nuke
	cp ../../solutions/lab1/*.sv .

original: copy

copy: nuke

clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys* *.debug

nuke: clean
	rm -rf *.sv

help:
	@echo =======================================================================
	@echo  " 								       "
	@echo  " USAGE: make target <seed=xxx> <verbosity=YYY> <test=ZZZ>              "
	@echo  " 								       "
	@echo  "  xxx is the random seed.  Can be any integer except 0. Defaults to 1  "
	@echo  "  YYY sets the verbosity filter.  Defaults to UVM_MEDIUM               "
	@echo  "  ZZZ selects the uvm test.       Defaults to test_base                "
	@echo  " 								       "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " all             => Compile TB and DUT files and run the simulation    "
	@echo  " compile         => Compile TB and DUT files                           "
	@echo  " run             => Run the simulation with seed                       "
	@echo  " random          => Run the simulation with random seed                "
	@echo  " dve_i           => Run simulation interactively with DVE              "
	@echo  "                                                                       "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help       => Displays this message.                                  "
	@echo  " clean      => Remove all intermediate simv and log files              "
	@echo  " nuke       => Remove all source code and debug files                  "
	@echo  " original   => Return content of lab back to original state            "
	@echo  " copy       => Copy all necessary files for starting lab               "
	@echo  " solution   => Copy all files from solutions directory                 "
	@echo  "								       "
	@echo  " ---------------------- EMBEDDED SETTINGS -----------------------------"
	@echo  " -timescale=\"1ns/100ps\"                                              "
	@echo  " -debug_all                                                            "
	@echo =======================================================================
