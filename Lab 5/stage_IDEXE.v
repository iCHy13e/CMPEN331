`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.28.23 12:36
// Project Name: Lab 4, Piplelined CPU
// Modules Contained: controlUnit, mux, e, regfile, IDEXE
//////////////////////////////////////////////////////////////////////////////////

// Module      : Control Unit
// Description : On signal change, set control signals based on op and func
// Input(s)    : op, func
// Output(s)   : wreg, m2reg, wmem, aluc, aluimm, regrt
module controlUnit(
    input[5:0] op, 
    input[5:0] func,

    output reg wreg, 
    output reg m2reg, 
    output reg wmem, 
    output reg[3:0] aluc, 
    output reg aluimm, 
    output reg regrt);
                    
    //lw instructions
    always @(*) begin
        case(op)
            6'b100011:
                begin
                    wreg = 1'b1;
                    m2reg = 1'b1;
                    wmem = 1'b0;
                    aluc = 4'b0010;
                    aluimm = 1'b1;
                    regrt  = 1'b1;
                end
        endcase
    end
endmodule 


// Module      : Mux (Multiplexer)
// Description : Sets the value of destReg to either rt or rd based on regrt
// Input(s)    : rt, rd, regrt
// Output(s)   : destReg
module mux(input [4:0] rt, input [4:0] rd, input regrt, output reg[4:0] destReg);

    always @(*) begin
        //if regrt = 1, destReg = rt 
        case(regrt)
            1'b1: destReg = rt;
            1'b0: destReg = rd;
        endcase
    end 
endmodule


// Module      : RegFile (Register File)
// Description : On initial, set all registers to 0. On negative clock edge, if wwreg = 1: set wdestReg = wbData
// Input(s)    : Clock, rs, rt, wdestReg, wbData
// Output(s)   : qa, qb
module reg_file(input clk, input wwreg, input [4:0] rs, input [4:0] rt, input [4:0] wdestReg, input [31:0] wbData, output reg[31:0] qa, output reg[31:0] qb);
    reg[31:0] RegFile[31:0];
    
    integer i;
    initial begin
		for (i=0; i<32; i=i+1) begin
		    RegFile[i] <= 32'b00000000000000000000000000000000;
		end
        assign qa = RegFile[rs];
        assign qb = RegFile[rt];
    end

    always @(negedge clk) begin
        if(wwreg == 1) begin
            RegFile[wdestReg] <= wbData;
        end
    end
endmodule 


// Module      : E (Sign Extend)
// Description : On signal change, set imm32 to sign extended imm
// Input(s)    : imm
// Output(s)   : imm32
module e(input [15:0] imm, output reg[31:0] imm32);
       
    //sets imm32 to imm
    always @(*)begin
        imm32 = {{16{imm[15]}}, imm[15:0]};
    end 

endmodule


// Module      : IDEXE (Instruction Decode Execute)
// Description : On positive clock edge, set all output signals to their respective input signals
// Input(s)    : Clock, wreg, m2reg, wmem, aluc, aluimm, destReg, qa, qb, imm32
// Output(s)   : Ewreg, em2reg, ewmem, ealuc, ealuimm, edestReg, eqa, eqb, eimm32
module IDEXE(
    input clk,

    input wreg,             output reg ewreg,
    input m2reg,            output reg em2reg,
    input wmem,             output reg ewmem,
    input [3:0] aluc,       output reg [3:0] ealuc,
    input aluimm,           output reg ealuimm,
    input [4:0] destReg,    output reg [4:0] edestReg,
    input [31:0] qa,        output reg [31:0] eqa,
    input [31:0] qb,        output reg [31:0] eqb,
    input [31:0] imm32,     output reg [31:0] eimm32);
        
    always @(posedge clk) begin
        ewreg <= wreg;
        em2reg <= m2reg;
        ewmem <= wmem;
        ealuc <= aluc;
        ealuimm <= aluimm; 
        edestReg <= destReg;
        eqa <= qa;
        eqb <= qb;
        eimm32 <= imm32;
    end 
endmodule
