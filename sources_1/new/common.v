`timescale 1ms/1ns
module dataRAM(
    input [9:0] addr,
    input [31:0] dataIn,
    input str,
    input clk,
    input [3:0]memChoose,
    output [31:0]dataOut,
    output [31:0]choosenOut
 );
    reg [31:0]ram[0:1023];
    assign dataOut = ram[addr];
    assign choosenOut = ram[memChoose];
    always @(posedge clk)
    begin
        if (str)
            ram[addr] = dataIn;
    end
 endmodule
 
 module instROM(
    input [9:0] addr,
    output [31:0] data
);
    reg [31:0]storage[0:1023];
    initial
        $readmemh("D:\\test.txt", storage);
    assign data = storage[addr];
endmodule

 module counter(
    input clk,
    input count,
    output [31:0]data
);
    reg [31:0]number;
    initial
        number = 0;
    assign data = number;
    always @(posedge clk)
        if (count)
            number = number + 1;
 endmodule
 
 module register(
    input [31:0] dataIn,
    input clk,
    input WE,
    output [31:0]dataOut
);
    reg [31:0] storage;
    initial
        storage = 0;
    assign dataOut = storage;
    always @(posedge clk)
        if (WE)
            storage = dataIn;
endmodule

module mux2(choose, data0, data1, result);
    parameter LENGTH = 32;
    input [LENGTH - 1 : 0] data0, data1;
    input choose;
    output reg [LENGTH - 1 : 0] result;
    
    always @(choose or data0 or data1)
        if (choose)
            result = data1;
        else
            result = data0;
endmodule

module mux4(choose, data0, data1, data2, data3, result);
    parameter LENGTH = 32;
    input [LENGTH - 1 : 0]data0, data1, data2, data3;
    output reg [LENGTH - 1 : 0] result;
    input [1 : 0] choose;
    
    always @(choose or data0 or data1 or data2 or data3)
        case (choose)
            0: result = data0;
            1: result = data1;
            2: result = data2;
            3: result = data3;
        endcase
endmodule