`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.28.23 12:36
// Project Name: Lab 4, Piplelined CPU
//////////////////////////////////////////////////////////////////////////////////

// Module      : Datapath
// Description : Connect all modules together
// Input(s)    : Clock
// Output(s)   : Module instructions
module dataPath(
    input clk,

    output [31:0] curPC,
    output wire [31:0] dinstOut,
    output ewreg,
    output em2reg,
    output ewmem,
    output [3:0] ealuc,
    output ealuimm,
    output [4:0] edestReg,
    output [31:0] eqa,
    output [31:0] eqb,
    output [31:0] eimm32,
    output mwreg,
    output mm2reg,
    output mwmem,
    output [4:0] mdestReg,
    output [31:0] mqb,
    output wwreg,
    output wm2reg,
    output [4:0] wdestReg,
    output [31:0] mr,
    output [31:0] wr,
    output [31:0] wdo);        

        wire [31:0] nextPC;
        wire [31:0] instOut;
        wire wreg;
        wire m2reg;
        wire wmem;
        wire [3:0] aluc;
        wire aluimm;
        wire regrt;
        wire [4:0] destReg;
        wire [31:0] qa;
        wire [31:0] qb;
        wire [31:0] imm32;
        wire [31:0] b;
        wire [31:0] r;
        wire [31:0] mdo;

        pc pc(clk, nextPC, curPC);
        adder adder(curPC, nextPC);               
        instMem instMem(curPC, instOut);                        
        IFID IFID(clk, instOut, dinstOut);
        controlUnit controlUnit(dinstOut[31:26], dinstOut[5:0], wreg, m2reg , wmem, aluc, aluimm, regrt);
        mux mux(dinstOut[20:16], dinstOut[15:11], regrt, destReg);
        e e(dinstOut[15:0], imm32);
        reg_file reg_file(dinstOut[25:21], dinstOut[20:16], qa, qb);
        IDEXE IDEXE(clk, wreg, ewreg, m2reg, em2reg, wmem, ewmem, aluc, ealuc, aluimm, ealuimm, destReg, edestReg, qa, eqa, qb, eqb, imm32, eimm32);  
        aluMUX aluMUX(ealuimm, eqb, eimm32, b);
        ALU ALU(eqa, b, ealuc, r);
        EXEMEM EXEMEM(clk, ewreg, mwreg, em2reg, mm2reg, ewmem, mwmem, edestReg, mdestReg, r, mr, eqb, mqb);
        dataMem dataMem(clk, mwmem, mr, mqb, mdo);
        MEMWB MEMWB(clk, mwreg, wwreg, mm2reg, wm2reg, mdestReg, wdestReg, mr, wr, mdo, wdo);
endmodule
