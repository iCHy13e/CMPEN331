`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 12.10.23 12:36
// Project Name: Final Project, Piplelined CPU
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
module pcAdder(input [31:0] curPC, output reg[31:0] nextPC);
             
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
        //add $3, $1, $2    000000 00001 00010 00011 00000 100000
        iMem[25] <= 32'b00000000001000110001100000100000;

        //sub $4, $9, $3    000000 01001 00011 00100 00000 100010
        iMem[26] <= 32'b00000001001000110010000000100010;

        //or $5, $3, $9     000000 00011 01001 00101 00000 100101
        iMem[27] <= 32'b00000000011010010010100000100101;

        //xor $6, $3, $9    000000 00011 01001 00110 00000 100110
        iMem[28] <= 32'b00000000011010010011000000100110;

        //and $7, $3, $9    000000 00011 01001 00111 00000 100100
        iMem[29] <= 32'b00000000011010010011100000100100;
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