#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtop.h"
//#include "Valu___024unit.h"

#define MAX_SIM_TIME 1000
vluint64_t sim_time = 0;

void click(Vtop* dut, VerilatedVcdC *m_trace) {
    uint ticks = 0;

    while (ticks < 6) {
        dut->clk ^= 1;
        dut->eval();
        m_trace->dump(sim_time);
        sim_time++;
        ticks++;
    }
}

int main(int argc, char** argv, char** env) {
    Vtop *dut = new Vtop;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    dut->rst = 1;
    click(dut, m_trace);

    dut->rst = 0;
    
    dut->rd = 2;
    dut->rs1 = 1;
    dut->imm12 = 1;
    dut->opcode = 1;
    click(dut, m_trace);
    
    dut->rd = 1;
    dut->rs1 = 1;
    dut->imm12 = 1;
    dut->opcode = 1;
    click(dut, m_trace);

    int count = 0;

    while (sim_time < MAX_SIM_TIME) {

        dut->rd = (count % 2) + 1;
        dut->rs1 = 1;
        dut->imm12 = (dut->imm12 * 2);
        dut->opcode = count < 10 ? 1 : 2;
        click(dut, m_trace);

        count = (count + 1) % 20;
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}