`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 10.20.23 22:23
// Module(s) Name: Testbench
// Project Name: Lab 3, Piplelined CPU Part 1
//////////////////////////////////////////////////////////////////////////////////

module testbench();
    reg clk_tb;

    wire [31:0] pc_tb;
    wire [31:0] dinstOut_tb;
    wire ewreg_tb;
    wire em2reg_tb;
    wire ewmem_tb;
    wire [3:0] ealuc_tb; 
    wire ealuimm_tb;
    wire [4:0] edestReg_tb;
    wire [31:0] eqa_tb;
    wire [31:0] eqb_tb;
    wire [31:0] eimm32_tb;

    dataPath dataPath_tb(clk_tb, pc_tb, dinstOut_tb, ewreg_tb, em2reg_tb, ewmem_tb, ealuc_tb, ealuimm_tb, edestReg_tb, eqa_tb, eqb_tb, eimm32_tb);

    initial begin
        clk_tb = 0;
    end
    always begin
        #1;
        clk_tb = ~clk_tb;
    end
endmodule