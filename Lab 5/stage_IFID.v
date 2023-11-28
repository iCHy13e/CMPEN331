`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.28.23 12:36
// Project Name: Lab 4, Piplelined CPU
// Modules Contained: PC, PCAdder, instMem, IFID
//////////////////////////////////////////////////////////////////////////////////

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

        //add $6, $2, $10 6'b000000, 5'b00001, 5'b01010, 5'b00110, 5'b00000, 6'b100000;
        iMem[29] <= 32'b00000000001010100011000000100000;
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