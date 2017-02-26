`timescale 1ns / 1ps

module redirect(
    input [31:0] regNum,
    input [31:0] regData,
    input [31:0] data4,
    input [31:0] rw4,
    input we4,
    input [31:0] data5,
    input [31:0] rw5,
    input we5,
    output [31:0] outData
    );
    
    wire equal4, equal5, choose4, choose5;
    wire [31:0]result5;
    assign equal4 = (regNum[4:0] === rw4[4:0]);
    assign equal5 = (regNum[4:0] === rw5[4:0]);
    assign choose4 = equal4 & we4;
    assign choose5 = equal5 & we5;
    
    mux2 #(32) dut1(choose5, regData, data5, result5);
    mux2 #(32) dut2(choose4, result5, data4, outData); 
endmodule
