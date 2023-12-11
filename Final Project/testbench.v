`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// School: PSU Main Campus
// Name: Justin Ngo
// 
// Create Date: 11.28.23 12:36
// Module(s) Name: Testbench
// Project Name: Lab 5, Piplelined CPU Part 3
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
    wire mwreg_tb;
    wire mm2reg_tb;
    wire mwmem_tb;
    wire [4:0] mdestReg_tb;
    wire [31:0] mqb_tb;
    wire wwreg_tb;
    wire wm2reg_tb;
    wire [4:0] wdestReg_tb; 
    wire [31:0] mr_tb;
    wire [31:0] wr_tb;
    wire [31:0] wdo_tb;

    dataPath dataPath_tb(clk_tb, pc_tb, dinstOut_tb, ewreg_tb, em2reg_tb, ewmem_tb, ealuc_tb, ealuimm_tb, edestReg_tb, eqa_tb, eqb_tb, eimm32_tb, mwreg_tb, mm2reg_tb, mwmem_tb, 
                        mdestReg_tb, mqb_tb, wwreg_tb, wm2reg_tb, wdestReg_tb, mr_tb, wr_tb, wdo_tb);


    initial begin
        clk_tb = 0;
    end
    always begin
        #1;
        clk_tb = ~clk_tb;
    end
endmodule