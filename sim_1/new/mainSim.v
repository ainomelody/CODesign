`timescale 1ms / 1ns

module mainSim;
    reg clk;
    wire [31:0]cycle, jump, number;
    main dut(.origCLK(clk), .cycleOut(cycle), .jumpOut(jump), .numPrintOut(number));
    initial
        clk = 0;
    always
         #1 clk = ~clk;
endmodule

module IFSim;   //测试通过，指令加载成功。问题：如何将PC初值置为0
    reg clk;
    wire [31:0]PCOut, IR;
    reg [31:0]PC;

    IFpart dut(clk, 0, PC, PCOut, IR);
    initial
    begin
        clk = 0;
        PC = 0;
    end
    always
        #1 clk = ~clk;
    always @(PCOut)
        PC = PCOut;
endmodule

module IDSim;
    reg [31:0]IR, Din;
    reg clk, WE;
    reg[4:0]RW;
    wire [31:0]PCOut, IROut, signal, R1, R2, R1Data, R2Data, RWOut;

    IDpart dut(40, IR, clk, Din, WE, RW, 0, PCOut, IROut, signal, R1, R2, R1Data, R2Data, RWOut);
    initial
    fork
        clk = 0;
        IR = 32'h0000000c;
        WE = 1;
        RW = 3;
        Din = 10;
        #4 WE = 0;
        #5 IR = 32'h00641020;
    join
    always
        #1 clk = ~clk;
endmodule

module EXSim;
    reg [31:0] PC, IR, signal, R1, R2, RW, R1Data, R2Data, result4, result5, RW4, RW5;
    reg WE4, WE5;
    
    wire [31:0]AluResult, R1DataOut, R2DataOut, signImm;
    wire AluEqual;
    
    EXpart dut(PC, IR, signal, R1, R2, RW, R1Data, R2Data, WE4, WE5, result4, result5, RW4, RW5 , , ,
                AluResult, AluEqual, R1DataOut, R2DataOut, , signImm);
    initial
    fork
        PC = 40;
        IR = 32'h00641020;
        WE4 = 0;
        WE5 = 0;
        R1 = 3;
        R2 = 4;
        RW = 2;
        R1Data = 1;
        R2Data = 2;
        signal = 32'h00048035;
        result4 = 4;
        result5 = 5;
        RW4 = 3;
        RW5 = 4;
        #1 WE4 = 1;
        #1 WE5 = 1;
        #2 RW4 = 4;
    join
endmodule

module MEMSim;
    reg [31:0]signal, aluResult, R1Data, R2Data, RW;
    reg clk;
    wire [31:0] memOut;
    
    MEMpart dut(.PC(8), .signal(signal), .aluResult(aluResult),
                .R1Data(R1Data), .R2Data(R2Data), .RW(RW), .clk(clk), .memOut(memOut));
    initial
    begin
        clk = 0;
        RW = 1;
        R2Data = 10;
        signal = 32'h00002015;
        aluResult = 4;
        R1Data = 20;
        #4 signal = 0;
        #2 aluResult = 8;
        #3 aluResult = 4;
    end
    always
        #1 clk = ~clk;
endmodule

module WBSim;
    reg [31:0]signal, aluResult, R1Data, R2Data, RW;
    wire halt, syscall, WEOut;
    wire [31:0]result5;
    WBpart dut(.PC(40), .signal(signal),.memData(32'h0010ffff), .aluResult(aluResult), .R1Data(R1Data), .R2Data(R2Data), .RW(RW), .halt(halt), .syscall(syscall),
                .result5(result5), .WEOut(WEOut));
    initial
    begin
        R1Data = 10;
        R2Data = 20;
        aluResult = 2;
        RW = 5;
        #1 signal = 32'h00008055;  //lh
        #1 signal = 32'h0000c015;  //lw
        #1 signal = 32'h00008015;  //add v0,zero,10
        #1 signal = 32'h0084813f;  //syscall
    end
endmodule