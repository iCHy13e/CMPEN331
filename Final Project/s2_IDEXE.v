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
    input [5:0] op, 
    input [5:0] func,
    input [4:0] rs,
    input [4:0] rt,
    
    //exe stage signals
    input [4:0] edestReg,
    input ewreg,
    input em2reg,

    //mem stage signals
    input [4:0] mdestReg,
    input mwreg,
    input mm2reg,

    output reg wreg, 
    output reg m2reg, 
    output reg wmem, 
    output reg[3:0] aluc, 
    output reg aluimm, 
    output reg regrt,
    output reg [1:0] fwdA,
    output reg [1:0] fwdB);
                    
    //instructions
    always @(*) begin
        case(op)
            //lw
            6'b100011:
                begin
                    wreg = 1'b1;
                    m2reg = 1'b1;
                    wmem = 1'b0;
                    aluc = 4'b0010;
                    aluimm = 1'b1;
                    regrt  = 1'b1;
                end
            
            //r type
            6'b000000:

                //func values come from https://inst.eecs.berkeley.edu/~cs61c/resources/MIPS_help.html
                begin case(func)
                    //add
                    6'b100000:
                        begin
                            wreg = 1'b1;
                            m2reg = 1'b0;
                            wmem = 1'b0;
                            aluc = 4'b0010;
                            aluimm = 1'b0;
                            regrt  = 1'b0;
                        end
                    
                    //sub
                    6'b100010:
                        begin
                            wreg = 1'b1;
                            m2reg = 1'b0;
                            wmem = 1'b0;
                            aluc = 4'b0110;
                            aluimm = 1'b0;
                            regrt  = 1'b0;
                        end
                    
                    //and
                    6'b100100:
                        begin
                            wreg = 1'b1;
                            m2reg = 1'b0;
                            wmem = 1'b0;
                            aluc = 4'b0000;
                            aluimm = 1'b0;
                            regrt  = 1'b0;
                        end
                    
                    //or
                    6'b100101:
                        begin
                            wreg = 1'b1;
                            m2reg = 1'b0;
                            wmem = 1'b0;
                            aluc = 4'b0001;
                            aluimm = 1'b0;
                            regrt  = 1'b0;
                        end
                    
                    //xor
                    6'b100110:
                        begin
                            wreg = 1'b1;
                            m2reg = 1'b0;
                            wmem = 1'b0;
                            aluc = 4'b0011;
                            aluimm = 1'b0;
                            regrt  = 1'b0;
                        end                        
                    endcase 
                end
        endcase
    end
    
endmodule 


// Module      : Mux (Multiplexer)
// Description : Sets the value of destReg to either rt or rd based on regrt
// Input(s)    : rt, rd, regrt
// Output(s)   : destReg
module regMUX(input [4:0] rt, input [4:0] rd, input regrt, output reg[4:0] destReg);

    always @(*) begin
        //if regrt = 1, destReg = rt 
        case(regrt)
            1: destReg <= rt;
            0: destReg <= rd;
        endcase
    end 
endmodule


// Module      : Forward MUX A
// Description : Set muxAOut based on fdwa
// Input(s)    : fwda, qa, r, mr, mdo
// Output(s)   : muxAOut
module fwdMUXA(input [1:0] fwda, input [31:0] qa, input [31:0] r, input [31:0] mr, input [31:0] mdo, output reg [31:0] muxAOut);
    
    always @(*) begin
        case(fwda)
            2'b00: muxAOut <= qa;
            2'b01: muxAOut <= r;
            2'b10: muxAOut <= mr;
            2'b11: muxAOut <= mdo;
        endcase
    end
endmodule


// Module      : Forward MUX B
// Description : Set muxBOut based on fwdb
// Input(s)    : fwdb. qb, r, mr, mdo
// Output(s)   : muxBOut
module fwdMUXB(input [1:0] fwdb, input [31:0] qb, input [31:0] r, input [31:0] mr, input [31:0] mdo, output reg [31:0] muxBOut);
        
    always @(*) begin
        case(fwdb)
            2'b00: muxBOut <= qb;
            2'b01: muxBOut <= r;
            2'b10: muxBOut <= mr;
            2'b11: muxBOut <= mdo;
        endcase
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
    input [31:0] muxAOut,   output reg [31:0] eqa,
    input [31:0] muxBOut,   output reg [31:0] eqb,
    input [31:0] imm32,     output reg [31:0] eimm32);
        
    always @(posedge clk) begin
        ewreg <= wreg;
        em2reg <= m2reg;
        ewmem <= wmem;
        ealuc <= aluc;
        ealuimm <= aluimm; 
        edestReg <= destReg;
        eqa <= muxAOut;
        eqb <= muxBOut;
        eimm32 <= imm32;
    end 
endmodule