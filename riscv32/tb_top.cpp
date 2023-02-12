#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtop.h"
//#include "Valu___024unit.h"

#define MAX_SIM_TIME 1000
vluint64_t sim_time = 0;


#define ADD 1
#define SUBS 2
#define LESSTHAN 3

#define ADDI 11
#define SUBSI 12
#define LESSTHANI 13

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

    dut->reset = 1;
    click(dut, m_trace);

    dut->reset = 0;
    dut->rd = 2;
    dut->rs1 = 1;
    dut->rs2 = 2;
    dut->imm12 = 1;
    dut->opcode = ADDI;
    click(dut, m_trace);
    
    int count = 0;
    int value = 1;

    while (sim_time < MAX_SIM_TIME) {
        dut->reset = 0;
        dut->rd = (count % 2) + 1;
        dut->rs1 = 1;
        dut->rs2 = dut->rd;
        dut->imm12 = value;
        dut->opcode = 
            count < 5 ? ADDI : 
            count < 10 ? ADD :
            count < 15 ? SUBS :
            SUBSI;
        click(dut, m_trace);
        
        dut->rd = 3;
        dut->rs1 = 1;
        dut->rs2 = 2;
        dut->imm12 = value;
        dut->opcode = LESSTHAN;
        click(dut, m_trace);

        dut->rd = 3;
        dut->rs1 = 1;
        dut->rs2 = 2;
        dut->imm12 = value;
        dut->opcode = LESSTHANI;
        click(dut, m_trace);

        count = (count + 1) % 20;
        value = (value >= 0x800) ? 1 : value * 2;

        if (count == 0) {
            dut->reset = 1;
            click(dut, m_trace);
        }
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}