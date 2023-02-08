
RISC-V cheatsheet:
https://itnext.io/risc-v-instruction-set-cheatsheet-70961b4bbe8

RISC-V spec:
https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf

Verilog intros:
   https://en.wikibooks.org/wiki/Programmable_Logic/Verilog
   https://docs.google.com/presentation/d/1Z2lC78etDyXQkNJCCm7jh33dabxklBc_uDffrtLVkDc/edit#slide=id.p1
   https://docs.google.com/presentation/d/1O38ivIfXeno3Cbbqb6LALjxkZoOjbUXKm6_47x9xqJw/edit#slide=id.p1
   logic vs wire vs reg: https://www.verilogpro.com/verilog-reg-verilog-wire-systemverilog-logic/



Instructions on how to use Verilator:
https://itsembedded.com/dhd/verilator_1/
    Namely:
    - Create verilog file (.sv)
    - Create main driver (testbed) in C++
        * Driver create instance of DUT
        * Updates signals
        * Collects traces
        * Dumps traces into waveform file
    - Use verilog to compile into C++
    - Use gcc to compile into executable
    - Run make (Makefile has all build/run instructions)
    - Use gtkwave to visualize trace (waveform)

Instructions to burn blinky into FPGA
Based on https://github.com/nesl/ice40_examples
    - Install tools:
        * Install yosys (synthesize)
        * arachne-pnr (place and route)
        * IceStorm (convert to bitstream)
        * Install Alchitry Labs (https://alchitry.com/alchitry-labs) on Windows 
          to get Alchitry Loader (to upload .bin file into board)
    - Copied blinky from ice40_examples
        * Modified footprint on Makefile to cb132 (guessed based on the label in the schematics)
        * Updated pins in pinmap.pcf based on schematics (https://cdn.alchitry.com/docs/alchitry_cu_sch.pdf)
        * Ended updating top.v to use the highest bits of counter
    - Run make (Makefile has all build/run instructions)
    - Opened Alchitry Loader from Windows, uploaded to CU from there.

Notes:
   - RST button is 0 when pressed, and 1 when not.