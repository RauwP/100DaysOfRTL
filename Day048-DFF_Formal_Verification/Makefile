# Makefile for Windows (MinGW) and Formal Verification

DAY  = day48
TIME = $$(date +'%Y%m%d-%H%M%S')

# Set the default target to 'formal'
all: formal

# The iverilog command is for simulation, not formal.
TOOLCMD = iverilog -o sim.vvp -I../ -Wall -Winfloop -Wno-timescale -gno-shared-loop-index -g2012

compile: clean
	$(TOOLCMD) -s $(DAY) $(DAY).sv

sim: clean
	$(TOOLCMD) -s $(DAY)_tb $(DAY).sv $(DAY)_tb.sv
	vvp ./sim.vvp
	gtkwave $(DAY).vcd -r ../gtkwaverc &

synth_build: clean
	echo read_verilog -sv -I../ $(DAY).sv > synth.ys
	echo hierarchy -top $(DAY) >> synth.ys
	echo proc; opt; techmap; opt >> synth.ys
	echo write_verilog synth.v >> synth.ys
	echo show -prefix $(DAY) -colors $(TIME) >> synth.ys

synth: synth_build
	yosys synth.ys

formal_build: clean
	echo [tasks] > $(DAY).sby
	echo prove >> $(DAY).sby
	echo [options] > $(DAY).sby
	echo mode bmc >> $(DAY).sby
	echo depth 1 >> $(DAY).sby
	echo [engines] >> $(DAY).sby
	echo smtbmc >> $(DAY).sby
	echo [script] >> $(DAY).sby
	echo read_verilog -sv -formal -I../ $(DAY).sv >> $(DAY).sby
	echo prep -top $(DAY) >> $(DAY).sby
	echo [files] >> $(DAY).sby
	echo $(DAY).sv >> $(DAY).sby
	echo ../prim_assert.sv >> $(DAY).sby
	echo ../prim_assert_yosys_macros.svh >> $(DAY).sby
	echo ../prim_assert_sec_cm.svh >> $(DAY).sby
	echo ../prim_flop_macros.sv >> $(DAY).sby

formal: formal_build
	sby -f $(DAY).sby

# Use Windows-compatible commands for 'clean'
clean:
	-del /F /Q sim.vvp synth.ys synth.v *.dot *.pid *.vcd *.sby > nul 2>&1
	-if exist $(DAY)_prove rmdir /S /Q $(DAY)_prove > nul 2>&1
	-if exist day1_formal rmdir /S /Q day1_formal > nul 2>&1
	-if exist $(DAY) rmdir /S /Q $(DAY) > nul 2>&1