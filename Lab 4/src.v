`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.11.23 22:15
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


// Module      : PC (Program Counter)
// Description : On positive clock edge, update curPC with value of nextPC
// Input(s)    : Clock, nextPC
// Output(s)   : curPC
module pc(input clk, input [31:0] nextPC, output reg[31:0] curPC);
    
    //Initialize pc to 100 
    initial begin
        curPC = 32'd100;   
    end      
    
    //Set pc equal to nextPC
    always @(posedge clk) begin 
        curPC <= nextPC;
    end 
endmodule


// Module      : Adder
// Description : On signal change, set nextPC to curPC + 4
// Input(s)    : curPC
// Output(s)   : nextPC
module adder(input [31:0] curPC, output reg[31:0] nextPC);
             
    always @(*) begin
        nextPC = curPC + 32'd4;
    end 

endmodule 


// Module      : InstMem (Instruction Memory)
// Description : On any signal change, set instOut to the value of IM at curPC
// Input(s)    : curPC
// Output(s)   : instOut
module instMem(input [31:0] curPC, output reg[31:0] instOut); 
                
    reg[31:0] iMem[63:0];

    initial begin
        //lw $2, 00($1) 6'b100011, 5'b00001, 5'b00010, 5'b00000, 5'b00000, 6'b000000;
        iMem[25] <= 32'b10001100001000100000000000000000;
        
        //lw $3, 04($1) 6'b100011, 5'b00001, 5'b00011, 5'b00000, 5'b00100, 6'b000000;
        iMem[26] <= 32'b10001100001000110000000100000000;
        
        //lw $4, 08($1) 6'b100011, 5'b00001, 5'b00100, 5'b00000, 5'b01000, 6'b000000;
        iMem[27] <= 32'b10001100001001000000001000000000;
        
        //lw $5, 12($1) 6'b100011, 5'b00001, 5'b00101, 5'b00000, 5'b01100, 6'b000000;
        iMem[28] <= 32'b10001100001001010000001100000000;
    end
    
    //sets the values of instOut
    always @ (*)begin
        instOut = iMem[curPC[31:2]];
    end
endmodule 


// Module      : IFID (Instruction Fetch Instruction Decode)
// Description : On positive clock edge, set dinstOut to instOut
// Input(s)    : Clock, instOut
// Output(s)   : dinstOut
module IFID(input clk, input[31:0] instOut, output reg[31:0] dinstOut);
            
    always @(posedge clk) begin 
        dinstOut <= instOut;
    end

endmodule 


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
// Description : On signal change, qa = rs, qb = rt
// Input(s)    : rs, rt
// Output(s)   : qa, qb
module reg_file(input [4:0] rs, input [4:0] rt, output reg[31:0] qa, output reg[31:0] qb);
    reg[31:0] RegFile[31:0];
    
    integer i;
    initial begin
		for (i=0; i<32; i=i+1) begin
		    RegFile[i] <= 32'b00000000000000000000000000000000;
		end
        assign qa = RegFile[rs];
        assign qb = RegFile[rt];
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

// Module      : ALUMUX (ALU Multiplexer)
// Description : If ealuimm 0: b = eqb, 1: b = eimm32
// Input(s)    : ealuimm, eqb, eimm32
// Output(s)   : b
module aluMUX(input ealuimm, input [31:0] eqb, input [31:0] eimm32, output reg[31:0] b);
        
        always @(*) begin
        //if ealuimm = 0, b = eqb
        if(ealuimm == 1) begin
            b <= eqb;
        end 
        //else, b = eimm32
        else begin
            b <= eimm32;
        end
    end 
endmodule


// Module      : ALU (Arithmetic Logic Unit)
// Description : On signal change, set r = eaq and b based on ealuc
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