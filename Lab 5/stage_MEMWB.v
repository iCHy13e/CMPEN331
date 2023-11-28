`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.28.23 12:36
// Project Name: Lab 4, Piplelined CPU
// Modules Contained: dataMem, EXEMEM
//////////////////////////////////////////////////////////////////////////////////

// Module      : DataMem (Data Memory)
// Description : On any signal change, mdo = mr, On negative clock edge, if mwmem = 1: mr = mqb
// Input(s)    : Clock, mwmem, mr, mqb
// Output(s)   : mdo
module dataMem(input clk, input mwmem, input [31:0] mr, input [31:0] mqb, output reg [31:0] mdo);
    
    reg[31:0] dMem[63:0];

    initial begin
        dMem[0]  <= 32'hA00000AA;
        dMem[4]  <= 32'h10000011;
        dMem[8]  <= 32'h20000022;
        dMem[12] <= 32'h30000033;
        dMem[16] <= 32'h40000044;
        dMem[20] <= 32'h50000055;
        dMem[24] <= 32'h60000066;
        dMem[28] <= 32'h70000077;
        dMem[32] <= 32'h80000088;
        dMem[36] <= 32'h90000099;
    end

    //On any signal change set mdo = mr
    always @ (*) begin
        mdo = mr;
    end

    //On negative clock edge, set mdo = mqb if mwmem = 1
    always @(negedge clk) begin
        if(mwmem == 1) begin
            mdo <= mqb;
        end
    end
endmodule


// Module      : MEMWB (Memory Write Back)
// Description : Set all output signals to their respective input signals
// Input(s)    : Clock, mwreg, mm2reg, mdestReg, mr, mdo
// Output(s)   : wwreg, wm2reg, wdestReg, wr, wdo
module MEMWB(
    input clk,

    input mwreg,            output reg wwreg,
    input mm2reg,           output reg wm2reg,
    input [4:0] mdestReg,   output reg [4:0] wdestReg,
    input [31:0] mr,        output reg [31:0] wr,
    input [31:0] mdo,       output reg [31:0] wdo);

    always @(posedge clk) begin
        wwreg <= mwreg;
        wm2reg <= mm2reg;
        wdestReg <= mdestReg;
        wr <= mr;
        wdo <= mdo;
    end
endmodule

// Module      : wbMUX (Write Back Multiplexer)
// Description : set wbData based on wm2reg
// Input(s)    : wr, wdo, wm2reg
// Output(s)   : wbData
module wbMUX(input [31:0] wr, input [31:0] wdo, input wm2reg, output reg [31:0] wbData);

    always @ (*) begin
        if(wm2reg == 1) begin
            wbData = wdo;
        end
        else begin
            wbData = wr;
        end
    end
endmodule
