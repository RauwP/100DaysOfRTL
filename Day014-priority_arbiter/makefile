#------------------------------------------------------------------------------
# GENERIC Makefile for SystemVerilog Projects (Final, Working Version)
#------------------------------------------------------------------------------
# This version correctly gathers all RTL source files from all sibling
# directories AND includes the local testbench file for compilation.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# 1. OS-dependent remove command
#------------------------------------------------------------------------------
ifeq ($(OS),Windows_NT)
  RM = del /Q /F
else
  RM = rm -f
endif

#------------------------------------------------------------------------------
# 2. Project-specific variables
#------------------------------------------------------------------------------
# IMPORTANT: Only change this variable for each project directory.
DAY        := day14
#------------------------------------------------------------------------------
TESTBENCH  := $(DAY)_tb
VVP_OUT    := sim.vvp
VCD_FILE   := $(DAY).vcd
YOSYS_SCRIPT := synth.ys
SYNTH_VERILOG := synth.v

IVERILOG   := iverilog -g2012 -Wall -Wno-timescale
VVP        := vvp
YOSYS      := yosys
GTKWAVE    := gtkwave

# Define the testbench source file name
TB_SRC     := $(TESTBENCH).sv

# --- AUTOMATIC PATH AND SOURCE DISCOVERY (RELIABLE) ---
# Get the parent directory (your project's root)
PARENT_DIR   := $(abspath ..)

# Create a complete list of ALL synthesizable .sv files from ALL sibling directories.
# The pattern `$(PARENT_DIR)/*/*.sv` finds all .sv files in all subdirectories.
ALL_RTL_FILES := $(filter-out %_tb.sv, $(wildcard $(PARENT_DIR)/*/*.sv))
# --- END AUTOMATIC DISCOVERY ---

#------------------------------------------------------------------------------
# 3. Phony targets
#------------------------------------------------------------------------------
.PHONY: all compile sim view build synth clean

all: sim view

#------------------------------------------------------------------------------
# 4. Compile for Simulation
#------------------------------------------------------------------------------
compile:
	@echo --> Compiling for simulation...
	@echo     Including all RTL files and the local testbench...
	$(IVERILOG) -o "$(VVP_OUT)" -s $(TESTBENCH) $(ALL_RTL_FILES) "$(TB_SRC)"

#------------------------------------------------------------------------------
# 5. Run simulation
#------------------------------------------------------------------------------
sim: compile
	@echo --> Running simulation (produces '$(VCD_FILE)')...
	$(VVP) "$(VVP_OUT)"

#------------------------------------------------------------------------------
# 6. View waveform
#------------------------------------------------------------------------------
view: sim
	@echo --> Launching GTKWave on '$(VCD_FILE)'...
	$(GTKWAVE) "$(VCD_FILE)" &

#------------------------------------------------------------------------------
# 7. Build Yosys script (synthesis)
#------------------------------------------------------------------------------
build:
	@echo --> Generating Yosys script '$(YOSYS_SCRIPT)'...
	@echo     Reading all synthesizable RTL files from project...
	@echo read_verilog -sv $(ALL_RTL_FILES) > "$(YOSYS_SCRIPT)"
	@echo hierarchy -check -top $(DAY) >> "$(YOSYS_SCRIPT)"
	@echo proc; opt; techmap; opt >> "$(YOSYS_SCRIPT)"
	@echo write_verilog "$(SYNTH_VERILOG)" >> "$(YOSYS_SCRIPT)"
	@echo quit >> "$(YOSYS_SCRIPT)"

#------------------------------------------------------------------------------
# 8. Run synthesis (Yosys)
#------------------------------------------------------------------------------
synth: build
	@echo --> Running synthesis via Yosys...
	$(YOSYS) -c "$(YOSYS_SCRIPT)"

#------------------------------------------------------------------------------
# 9. Clean up intermediates
#------------------------------------------------------------------------------
clean:
	@echo --> Removing generated files...
	$(RM) "$(VVP_OUT)" "$(VCD_FILE)" "$(YOSYS_SCRIPT)" "$(SYNTH_VERILOG)" *.dot *.dot.pid Compiling Launching Removing Running