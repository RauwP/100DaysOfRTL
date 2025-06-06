# Makefile for Day2 project with SystemVerilog support

DAY := day2
SRC := $(DAY).sv
TB := $(DAY)_tb.sv
TOP := day2_tb
VVP := sim.vvp
VCD := $(DAY).vcd
YOSYS_SCRIPT := synth.ys
SYN_V := synth.v

IVER := iverilog -g2012 -Wall -Wno-timescale
VVP_CMD := vvp
YOSYS := yosys
GTKWAVE := gtkwave

.PHONY: all compile sim view build synth clean

all: sim view

compile:
	$(IVER) -o $(VVP) -s $(TOP) $(SRC) $(TB)

sim: compile
	$(VVP_CMD) $(VVP)

view: sim
	$(GTKWAVE) $(VCD) &

build:
	@echo "Generating Yosys script with SystemVerilog support..."
	cat > $(YOSYS_SCRIPT) << EOF
read_verilog -sv $(SRC)
hierarchy -check -top $(DAY)
proc
opt
techmap
opt
write_verilog $(SYN_V)
quit
EOF

synth: build
	@echo "Running synthesis (Yosys)..."
	$(YOSYS) -c $(YOSYS_SCRIPT)

clean:
	rm -f $(VVP) $(VCD) $(YOSYS_SCRIPT) $(SYN_V) *.dot *.dot.pid
