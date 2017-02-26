`timescale 1ns / 1ps

module regBuf(
    input WE,
    input clk,
    input reset,
    input [31:0]in1,
    input [31:0]in2,
    input [31:0]in3,
    input [31:0]in4,
    input [31:0]in5,
    input [31:0]in6,
    input [31:0]in7,
    input [31:0]in8,
    output [31:0]out1,
    output [31:0]out2,
    output [31:0]out3,
    output [31:0]out4,
    output [31:0]out5,
    output [31:0]out6,
    output [31:0]out7,
    output [31:0]out8
);
    wire [31:0] bitMask, data1, data2, data3, data4, data5, data6, data7, data8;
    assign bitMask = {32{~reset}};
    assign data1 = bitMask & in1;
    assign data2 = bitMask & in2;
    assign data3 = bitMask & in3;
    assign data4 = bitMask & in4;
    assign data5 = bitMask & in5;
    assign data6 = bitMask & in6;
    assign data7 = bitMask & in7;
    assign data8 = bitMask & in8;
    
    register dut1(data1, clk, WE, out1);
    register dut2(data2, clk, WE, out2);
    register dut3(data3, clk, WE, out3);
    register dut4(data4, clk, WE, out4);
    register dut5(data5, clk, WE, out5);
    register dut6(data6, clk, WE, out6);
    register dut7(data7, clk, WE, out7);
    register dut8(data8, clk, WE, out8);
    
endmodule
