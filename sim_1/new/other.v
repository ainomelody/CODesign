`timescale 1ms/1ns
module regFileSim;
    reg [4:0]reg1, reg2, rw;
    reg [31:0]Din;
    reg clk, we;
    wire [31:0]data1, data2;
    regfile dut(reg1, reg2, rw, Din, we, clk, data1, data2);
    
    initial
    begin
        clk = 0;
        Din = 1;
        we = 0;
        reg1 = 0;
        reg2 = 0;
        rw = 0;
        #1 we = 1;
        #3 reg1 = 5;
        rw = 5;
    end
    always
        #1 clk = ~clk;
endmodule

module redirectSim;
    reg we4, we5;
    reg[31:0] rw4, rw5;
    wire [31:0]out; 
    redirect dut(3, 10, 1, rw4, we4, 4, rw5, we5, out);
    initial
    fork
        we4 = 0;
        we5 = 0;
        rw4 = 4;
        rw5 = 3;
    join
endmodule

module RAMSim;
    reg [9:0] addr;
    reg [31:0]dataIn;
    reg str, clk;
    wire [31:0] out, chooseOut;
    
    dataRAM dut(addr, dataIn, str, clk, 0, out, chooseOut);
    initial
    begin
        clk = 0;
        addr = 0;
        dataIn = 10;
        str = 0;
        #1 str = 1;
        #1 clk = 1;
        #1 clk = 0;
        str = 0;
        #1 addr = 8;
        #1 addr = 16;
    end
endmodule

module regBufSim;
    reg WE, clk, reset;
    wire [31:0]out;
    regBuf dut(.WE(WE), .clk(clk), .reset(reset), .in1(10), .out1(out));
    initial
    begin
        WE = 1;
        reset = 0;
        clk = 0;
        #1 clk = 1;
        #1 clk = 0;
        #1 reset = 1;
        #1 clk = 1;
        #1 reset = 0;
        WE = 0;
        #1 clk = 0;
        #1 clk = 1;
    end
endmodule

module aluSim;
    reg [31:0]x,y;
    reg [3:0]op;
    wire [31:0]result;
    wire equal;
    alu dut(x, y, op, result, equal);
    initial
    begin
        op = 5;
        x = 4;
        y = 0;
        #1 y = 1;
    end
endmodule