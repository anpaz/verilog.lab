# Project setup
MODULE    = top
PROJ      = riscv32
BUILD     = ./build
DEVICE    = 8k
FOOTPRINT = cb132

# Files
FILES = top.sv alu.sv memory.sv

# Top level parameters to override fro simulation
# -- none -- 

.PHONY: build clean verilate pack sim graph

# Verilator simulation exe:
$(BUILD)/V$(MODULE): .stamp.verilate
	make -C $(BUILD) -f V$(MODULE).mk V$(MODULE)

# Verilate module:
.stamp.verilate: $(FILES) tb_$(MODULE).cpp
	verilator -Wall --trace --Mdir $(BUILD) -GWIDTH=16 --exe tb_$(MODULE).cpp -cc $(FILES)

# Generate waveform from simulation and open it in gtkwave
waves: waveform.vcd
	gtkwave waveform.vcd

# Generate waveform from simulation
waveform.vcd: $(BUILD)/V$(MODULE)
	$(BUILD)/V$(MODULE)

# Compile verilog to FPGA bin:
$(BUILD)/$(PROJ).bin: $(FILES)
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

dot:
	yosys \
		-p "read_verilog -sv -formal $(FILES)" \
		-p "hierarchy -check -top top" \
		-p "proc" \
		-p "show -prefix $(PROJ) -notitle -colors 2 -width -format dot"
	xdot $(PROJ).dot

verilate: .stamp.verilate
sim: waveform.vcd
pack: $(BUILD)/$(PROJ).bin

build: $(BUILD)/$(PROJ).bin $(BUILD)/V$(MODULE)

# Might need for Mac: export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"