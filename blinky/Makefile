# Project setup
MODULE    = top
PROJ      = blinky
BUILD     = ./build
DEVICE    = 8k
FOOTPRINT = cb132

# Files
FILES = top.sv

# Top level parameters to override fro simulation
OFFSET = 0

.PHONY: all clean verilate pack sim

# Verilator simulation exe:
$(BUILD)/V$(MODULE): .stamp.verilate
	make -C $(BUILD) -f V$(MODULE).mk V$(MODULE)

# Verilate module:
.stamp.verilate: $(MODULE).sv tb_$(MODULE).cpp
	verilator -Wall --trace --Mdir $(BUILD) -cc $(FILES) -GOFFSET=$(OFFSET) --exe tb_$(MODULE).cpp

# Generate waveform from simulation and open it in gtkwave
waves: waveform.vcd
	gtkwave waveform.vcd

# Generate waveform from simulation
waveform.vcd: $(BUILD)/V$(MODULE)
	$(BUILD)/V$(MODULE)

# Compile verilog to FPGA bin:
$(BUILD)/$(PROJ).bin:
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	yosys -p "synth_ice40 -top top -blif $(BUILD)/$(PROJ).blif" $(FILES)
	# Place and route using arachne
	arachne-pnr -d $(DEVICE) -P $(FOOTPRINT) -o $(BUILD)/$(PROJ).asc -p pinmap.pcf $(BUILD)/$(PROJ).blif
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

clean:
	rm build/*

verilate: .stamp.verilate
sim: waveform.vcd
pack: $(BUILD)/$(PROJ).bin

all: $(BUILD)/$(PROJ).bin $(BUILD)/V$(MODULE)

