# Makefile for UVM Lab2

test = test_base
program_path = .
PROGRAM_TOP = ${program_path}/test.sv
package_path = ./packages
PACKAGES = ${package_path}/fifo_stimulus_pkg.sv ${package_path}/fifo_env_pkg.sv ${package_path}/fifo_test_pkg.sv
TEST_TOP = ${PACKAGES} ${PROGRAM_TOP}
rtl_path = .
DUT = $(rtl_path)/fifo.v $(rtl_path)/fifo_io.sv 
HARNESS_TOP = $(rtl_path)/fifo_test_top.sv
TOP = ${HARNESS_TOP} ${TEST_TOP}

log = simv.log
verbosity = UVM_MEDIUM
uvm_ver = uvm-1.2
seed = 1
#seed = 15656
defines =
uvm_defines = UVM_NO_DEPRECATED+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR+UVM_VERDI_COMPWAVE
plus = UVM_VEDI_TRACE=COMPWAVE +UVM_VERDI_TRACE=HIER
option = UVM_TR_RECORD +UVM_LOG_RECORD
trace =
#trace = UVM_OBJECTION_TRACE

compile_switches = -kdb -full64 -sverilog -lca -debug_access+all -kdb +vcs+vcdpluson -timescale="1ns/100ps" -l comp.log -ntb_opts ${uvm_ver} ${DUT} ${TOP} +define+${uvm_defines}+${defines}
runtime_switches = -l ${log} +UVM_TESTNAME=${test} +UVM_VERBOSITY=${verbosity} +${plus} +${trace} +${option}

all: simv run


simv compile: *.sv ${DUT} ${TOP}
ifeq ($(CES64),TRUE)
	vcs -full64 ${compile_switches}
	@echo "Compiled in 64-bit mode"
else
	vcs ${compile_switches}
	@echo "Compiled in 32-bit mode"
endif																																																								  

run:
	./simv +ntb_random_seed=${seed} ${runtime_switches}

random: simv
	./simv +ntb_random_seed_automatic ${runtime_switches}

dve_i: simv
	./simv -gui=dve +ntb_random_seed=$(seed) ${runtime_switches} &

verdi_i: simv
	./simv -gui=verdi +ntb_random_seed=$(seed) ${runtime_switches} +UVM_VERDI_TRACE &

verdi:
	verdi -ssf novas.fsdb &


clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys* novas.* *.dat *.fsdb verdi* work* vlog* assert* 

help:
	@echo =======================================================================
	@echo  "									   "
	@echo  " USAGE: make target <seed=xxx> <verbosity=YYY> <test=ZZZ>			  "
	@echo  "									   "
	@echo  "  xxx is the random seed.  Can be any integer except 0. Defaults to 1  "
	@echo  "  YYY sets the verbosity filter.  Defaults to UVM_MEDIUM			   "
	@echo  "  ZZZ selects the uvm test.	   Defaults to test_base				"
	@echo  "									   "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " all			 => Compile TB and DUT files and run the simulation	"
	@echo  " compile		 => Compile TB and DUT files						   "
	@echo  " run			 => Run the simulation with seed					   "
	@echo  " random		  	 => Run the simulation with random seed				"
	@echo  " dve_i		     => Run simulation interactively with DVE			  "
	@echo  "																	   "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help	   		 => Displays this message								   "
	@echo  " clean	  		 => Remove all intermediate simv and log files			  "
	@echo  "									   "
	@echo  " ---------------------- EMBEDDED SETTINGS -----------------------------"
	@echo  " -timescale=\"1ns/100ps\"											  "
	@echo  " -debug_all															"
	@echo =======================================================================

