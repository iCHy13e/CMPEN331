`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.28.23 12:36
// Project Name: Lab 4, Piplelined CPU
// Modules Contained: aluMux, ALU, EXEMEM
//////////////////////////////////////////////////////////////////////////////////

// Module      : ALUMUX (ALU Multiplexer)
// Description : If ealuimm 0: b = eqb, 1: b = eimm32
// Input(s)    : ealuimm, eqb, eimm32
// Output(s)   : b
module aluMUX(input ealuimm, input [31:0] eqb, input [31:0] eimm32, output reg[31:0] b);
        
        always @(*) begin
         //if ealuimm = 0, b = eqb
        case(ealuimm)
            0: b <= eqb;
            1: b <= eimm32;
        endcase
    end 
endmodule


// Module      : ALU (Arithmetic Logic Unit)
// Description : On signal change, set r = eqa and b based on ealuc
// Input(s)    : ea, b, ealuc
// Output(s)   : r
module ALU(input [31:0] eqa, input [31:0] b, input [3:0] ealuc, output reg[31:0] r);
    //add, sub, and, or, xor
    always @(*) begin
        if(ealuc == 4'b0010) begin
            r <= eqa + b;
        end
    end
endmodule


// Module      : EXEMEM (Execute Memory)
// Description : On positive clock edge, set all output signals to their respective input signals
// Input(s)    : ewreg, em2reg, ewmem, edestReg, eqa, eqb, eimm32
// Output(s)   : mwreg, mm2reg, mwmem, mdestReg, mqa, mqb, memm32
module EXEMEM(
    input clk,

    input ewreg,            output reg mwreg,
    input em2reg,           output reg mm2reg,
    input ewmem,            output reg mwmem,                   
    input [4:0] edestReg,   output reg [4:0] mdestReg,       
    input [31:0] r,         output reg [31:0] mr,
    input [31:0] eqb,       output reg [31:0] mqb);
    
    always @(posedge clk) begin
        mwreg <= ewreg;
        mm2reg <= em2reg;
        mwmem <= ewmem;
        mdestReg <= edestReg;
        mr <= r;
        mqb <= eqb;
    end
endmodule