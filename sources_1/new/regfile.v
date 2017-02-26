`timescale 1ms / 1ns

module regfile(
    input [4:0] reg1,
    input [4:0] reg2,
    input [4:0] writeReg,
    input [31:0] Din,
    input WE,
    input clk,
    output [31:0] data1,
    output [31:0] data2
    );
    
    reg [31:0]registers[0:31];
    initial
        registers[0] = 0;
    assign data1 = registers[reg1];
    assign data2 = registers[reg2];
    always @(negedge clk)       //¸ÄÏÂ½µÑØ
        if (WE && writeReg != 0)
            registers[writeReg] = Din;
endmodule
