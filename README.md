
RISC-V cheatsheet:
https://itnext.io/risc-v-instruction-set-cheatsheet-70961b4bbe8

RISC-V spec:
https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf


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
- Run
- Use gtkwave to visualize trace (waveform)

