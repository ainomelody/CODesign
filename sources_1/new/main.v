`timescale 1ms / 1ns
//`define DEBUG
module main(
`ifndef DEBUG
    input origCLK,
    input [1:0]dataChoose,
    input [3:0]memChoose,
    output [7 : 0]anodes,
    output [7 : 0]cathnodes
`endif
);
`ifdef DEBUG
    reg origCLK;
    reg [3:0]memChoose;
    initial
    begin
        origCLK = 0;
        memChoose = 0;
    end
    always
        #1 origCLK = ~origCLK;
`else
    wire [7:0]decode1, decode2, decode3, decode4, decode5, decode6, decode7, decode8;
    reg [31:0]numShowOnLED;
`endif
    wire clk, loaduse, jump, divCLK;      //接时钟生成电路，loaduse判断电路,跳转判断电路
    wire [31:0] result4, result5, RW4, RW5, R2ToPrint, haltOut, bAddr, cycleNum, jumpNum, memChoosenOut;   //接PC选择电路
    reg [31:0] targetPC;
    wire WE4, WE5, EX_AluEqual, halt, syscall, WEOut, bJump, bltzJump;
    wire [31:0]IF_PCOut, IF_IROut, buf1Out1, buf1Out2;
    wire [31:0]ID_PCOut, ID_IROut, ID_signalOut, ID_R1Out, ID_R2Out, ID_R1DataOut, ID_R2DataOut, ID_RWOut,
                buf2Out1, buf2Out2, buf2Out3, buf2Out4, buf2Out5, buf2Out6, buf2Out7, buf2Out8;
    wire [31:0]EX_PCOut, EX_signalOut, EX_AluResult, EX_R1DataOut, EX_R2DataOut, EX_RWOut, EX_signImm,
                buf3Out1, buf3Out2, buf3Out3, buf3Out4, buf3Out5, buf3Out6;
    wire [31:0]MEM_PCOut, MEM_signalOut, MEM_memOut, MEM_aluResultOut, MEM_R1DataOut, MEM_R2DataOut, MEM_RWOut,
                buf4Out1, buf4Out2, buf4Out3, buf4Out4, buf4Out5, buf4Out6, buf4Out7;
    wire [31:0]numPrint;       
    assign cycleOut = cycleNum, jumpOut = jumpNum; 
    IFpart IFcrc(.clk(clk), .loaduse(loaduse), .PC(targetPC), .nextPC(IF_PCOut), .IR(IF_IROut));
    regBuf IFID(.WE(~loaduse), .clk(clk), .reset(jump), .in1(IF_PCOut), .in2(IF_IROut), .out1(buf1Out1), .out2(buf1Out2));
    IDpart IDcrc(.PC(buf1Out1), .IR(buf1Out2), .clk(clk), .Din(result5), .WE(WEOut), .RW(RW5[4:0]), .loaduse(loaduse), .PCout(ID_PCOut), 
                 .IRout(ID_IROut), .signalOut(ID_signalOut), .R1(ID_R1Out), .R2(ID_R2Out), .R1Data(ID_R1DataOut), .R2Data(ID_R2DataOut), .RWOut(ID_RWOut));
    regBuf IDEX(.WE(1'b1), .clk(clk), .reset(jump), .in1(ID_PCOut), .in2(ID_IROut), .in3(ID_signalOut), .in4(ID_R1Out), 
                .in5(ID_R2Out), .in6(ID_R1DataOut), .in7(ID_R2DataOut), .in8(ID_RWOut), .out1(buf2Out1), .out2(buf2Out2), .out3(buf2Out3), 
                .out4(buf2Out4), .out5(buf2Out5), .out6(buf2Out6), .out7(buf2Out7), .out8(buf2Out8));
    EXpart EXcrc(.PC(buf2Out1), .IR(buf2Out2), .signal(buf2Out3), .R1(buf2Out4), .R2(buf2Out5), .RW(buf2Out8), .R1Data(buf2Out6), .R2Data(buf2Out7), .WE4(WE4), .WE5(WE5), 
                 .result4(result4), .result5(result5), .RW4(RW4), .RW5(RW5), .PCout(EX_PCOut), .signalOut(EX_signalOut), .AluResult(EX_AluResult), 
                 .AluEqual(EX_AluEqual), .R1DataOut(EX_R1DataOut), .R2DataOut(EX_R2DataOut), .RWOut(EX_RWOut), .signImm(EX_signImm));
    regBuf EXMEM(.WE(1'b1), .clk(clk), .reset(1'b0), .in1(EX_PCOut), .in2(EX_signalOut), .in3(EX_AluResult), .in4(EX_R1DataOut), .in5(EX_R2DataOut), .in6(EX_RWOut),
                .out1(buf3Out1), .out2(buf3Out2), .out3(buf3Out3), .out4(buf3Out4), .out5(buf3Out5), .out6(buf3Out6));
    MEMpart MEMcrc(.PC(buf3Out1), .signal(buf3Out2), .aluResult(buf3Out3), .R1Data(buf3Out4), .R2Data(buf3Out5), .RW(buf3Out6), .clk(clk),
                   .PCOut(MEM_PCOut), .signalOut(MEM_signalOut), .memOut(MEM_memOut), .aluResultOut(MEM_aluResultOut), .R1DataOut(MEM_R1DataOut), 
                   .R2DataOut(MEM_R2DataOut), .RWOut(MEM_RWOut), .WE4(WE4), .result4(result4), .RW4(RW4), .memChoose(memChoose), .memChoosenOut(memChoosenOut));
    regBuf MEMWB(.WE(1'b1), .clk(clk), .reset(1'b0), .in1(MEM_PCOut), .in2(MEM_signalOut), .in3(MEM_memOut), .in4(MEM_aluResultOut), .in5(MEM_R1DataOut), .in6(MEM_R2DataOut), .in7(MEM_RWOut),
                .out1(buf4Out1), .out2(buf4Out2), .out3(buf4Out3), .out4(buf4Out4), .out5(buf4Out5), .out6(buf4Out6), .out7(buf4Out7));
    WBpart WBcrc(.PC(buf4Out1), .signal(buf4Out2), .memData(buf4Out3), .aluResult(buf4Out4), .R1Data(buf4Out5), .R2Data(buf4Out6), .RW(buf4Out7), 
                 .halt(halt), .syscall(syscall), .result5(result5), .RW5(RW5), .WE5(WE5), .WEOut(WEOut), .R2DataOut(R2ToPrint));
    
    register haltReg({32{halt}}, clk, 1'b1, haltOut);
    mux2 #(1) muxCLK(haltOut[0], divCLK, 1'b0, clk);
    
    assign loaduse = ((EX_RWOut === ID_R1Out) || (EX_RWOut === ID_R2Out)) && EX_signalOut[14];
    assign bAddr = (EX_signImm << 2) + EX_PCOut;
    assign bJump = EX_AluEqual & EX_signalOut[10] | ~EX_AluEqual & EX_signalOut[11];
    assign bltzJump = EX_signalOut[7] & EX_R1DataOut[31];
    assign jump = bltzJump | bJump |  EX_signalOut[9] | EX_signalOut[17];
    
    always @(*)
    begin
        if (~jump)
            targetPC = IF_PCOut;
        else if (bJump)
            targetPC = bAddr;
        else if (EX_signalOut[17])
            targetPC = EX_R1DataOut;
        else if (EX_signalOut[9])
            targetPC = {4'b0000, buf2Out2[25:0], 2'b00};
        else
            targetPC = EX_AluResult;
    end
    register sysPrint(R2ToPrint, clk, syscall & ~halt, numPrint);
    counter cycCount(clk, 1'b1, cycleNum);
    counter jumpCount(clk, jump, jumpNum);
`ifndef DEBUG
    freqDiv #(1000000, 20) clkPro(origCLK, 0, divCLK);
    always @(*)
        case (dataChoose)
            0: numShowOnLED = numPrint;
            1: numShowOnLED = cycleNum;
            2: numShowOnLED = jumpNum;
            3: numShowOnLED = memChoosenOut;
        endcase
    display printOnBoard(origCLK, decode1, decode2, decode3, decode4, decode5, decode6,
                         decode7, decode8, anodes, cathnodes);
    decoder part1(numShowOnLED[3:0], decode1);
    decoder part2(numShowOnLED[7:4], decode2);
    decoder part3(numShowOnLED[11:8], decode3);
    decoder part4(numShowOnLED[15:12], decode4);
    decoder part5(numShowOnLED[19:16], decode5);
    decoder part6(numShowOnLED[23:20], decode6);
    decoder part7(numShowOnLED[27:24], decode7);
    decoder part8(numShowOnLED[31:28], decode8);
`else
    assign divCLK = origCLK;
`endif
endmodule

module IFpart(
    input clk,
    input loaduse,
    input [31:0]PC,
    output [31:0]nextPC,
    output [31:0]IR
);
    wire [31:0] pcOut;

    assign nextPC = pcOut + 4;
    
    register dut1(PC, clk, ~loaduse, pcOut);
    instROM dut2(pcOut[11:2], IR);
endmodule

module IDpart(
    input [31:0] PC, input [31:0] IR, input clk, input [31:0] Din, input WE, input [4:0] RW, input loaduse,
    output [31:0] PCout, output [31:0]IRout, output [31:0]signalOut, output [31:0]R1, output [31:0]R2,
    output [31:0]R1Data, output [31:0]R2Data, output [31:0]RWOut
);
    wire cp0, mfc0, mtc0, syscall, eret, R, jal, ctrlWE;
    wire [4:0]R1MuxOut, R2MuxOut, RWMuxOut1, RWMuxOut2;
    wire [31:0]signal;
    
    assign PCout = PC, IRout = IR;
    assign cp0 = (IR[31:26] === 6'b001010);
    assign mfc0 = cp0 & (IR[25:21] === 5'b00000);
    assign mtc0 = cp0 & (IR[25:21] === 5'b00100);
    assign eret = cp0 & (IR[5:0] === 6'b011000);
    assign syscall = (IR === 32'h0000000c);
    assign signal[18] = R, signal[12] = jal, signal[19] = cp0, signal[20] = mfc0, signal[21] = mtc0;
    assign signal[22] = eret, signal[23] = syscall, signal[25] = (IR === 32'h00000000);
    assign signal[24] = 0, signal[31:26] = 0;
    assign R2 = R2MuxOut, R1 = R1MuxOut;
    assign signal[15] = ctrlWE & ~syscall;
    
    controller dut1(IR[31:26], IR[5:0], signal[3:0], signal[6], signal[7], signal[8], signal[9], signal[10], signal[11], 
                    jal, signal[5:4], signal[13], signal[14], ctrlWE, signal[16], signal[17], R);
    mux2 #(5) dut2(syscall, IR[25:21], 5'b00010, R1MuxOut);
    mux2 #(5) dut3(syscall, IR[20:16], 5'b00100, R2MuxOut);
    mux2 #(32) dut4(loaduse, signal, 0, signalOut);
    mux2 #(5) dut5(R, IR[20:16], IR[15:11], RWMuxOut1);
    mux2 #(5) dut6(jal, RWMuxOut1, 5'b11111, RWMuxOut2);
    mux2 #(32) dut7(loaduse, {{27{1'b0}}, RWMuxOut2}, 0, RWOut);
    regfile dut8(R1MuxOut, R2MuxOut, RW, Din, WE, clk, R1Data, R2Data);
endmodule

module EXpart(
    input [31:0] PC, input [31:0] IR,
    input [31:0] signal,
    input [31:0] R1, input [31:0] R2, input [31:0] RW,
    input [31:0] R1Data, input [31:0] R2Data,
    input WE4, input WE5, input [31:0] result4, input [31:0]result5, input [31:0]RW4, input [31:0]RW5,
    output [31:0] PCout, output [31:0] signalOut, output [31:0] AluResult, output AluEqual,
    output [31:0]R1DataOut, output[31:0]R2DataOut, output [31:0]RWOut,
    output [31:0] signImm
);
    wire [31:0] alux1, alux2, aluy1, aluy2, aluy3, aluy4;
    
    assign PCout = PC, signalOut = signal, RWOut = RW;
    assign signImm = {{16{IR[15]}}, IR[15:0]};
`ifdef DEBUG
    always @(IR or AluResult)
        if (PC == 32'hc)
            $display("\n\nsll:x=%d,y=%d,op=%d\n", alux2, aluy4, signal[3:0]);
`endif
    redirect dut1(R1, R1Data, result4, RW4, WE4, result5, RW5, WE5, R1DataOut);
    redirect dut2(R2, R2Data, result4, RW4, WE4, result5, RW5, WE5, R2DataOut);
    mux2 #(32) dut3(signal[8], R1DataOut, R2DataOut, alux1);
    mux2 #(32) dut4(signal[7], alux1, PC, alux2);
    mux4 #(32) dut5(signal[5:4], {16'h0000,IR[15:0]}, signImm, R2DataOut, {{14{IR[15]}}, IR[15:0], 2'b00}, aluy1);
    mux2 #(32) dut6(signal[8], R2DataOut, {{27{1'b0}}, IR[10:6]}, aluy2);
    mux2 #(32) dut7(signal[16], aluy2, R1DataOut, aluy3);
    mux2 #(32) dut8(signal[18], aluy1, aluy3, aluy4);
    alu dut9(alux2, aluy4, signal[3:0], AluResult, AluEqual);
endmodule

module MEMpart(
    input [31:0] PC, input [31:0] signal, input [31:0]aluResult,
    input [31:0] R1Data, input [31:0] R2Data, input [31:0] RW, input clk, input [3:0]memChoose,
    output [31:0] PCOut, output[31:0] signalOut, output [31:0] memOut,
    output [31:0] aluResultOut, output [31:0] R1DataOut, output [31:0] R2DataOut,
    output [31:0] RWOut, output WE4, output [31:0] result4, output [31:0] RW4, output [31:0] memChoosenOut
);
    wire str;
    assign PCOut = PC, signalOut = signal, aluResultOut = aluResult, R1DataOut = R1Data,
           R2DataOut = R2Data, RWOut = RW, WE4 = signal[15], result4 = aluResult, RW4 = RW;
    assign str = ~signal[25] & ~signal[23] & signal[13];
    dataRAM dut1(.addr(aluResult[11:2]), .dataIn(R2Data), .str(str), .clk(clk), .dataOut(memOut), .memChoose(memChoose), .choosenOut(memChoosenOut));
`ifdef DEBUG
    always @(posedge clk)
        if (str)
            $display("\nMemWrite:PC=%d,data=%d,addr=%d\n", PC, R2Data, aluResult[11:2]);
`endif
endmodule

module WBpart(
    input [31:0]PC, input [31:0]signal, input [31:0]memData, input [31:0]aluResult,
    input [31:0]R1Data, input[31:0]R2Data, input [31:0]RW,
    output halt, output syscall, output [31:0]result5, output [31:0]RW5, output WE5, output WEOut,
    output [31:0]R2DataOut
);
    wire [15:0]lhOneWord;
    wire [31:0]lhOut, lwOut;
    assign halt = (R1Data === 32'h0000000a) && signal[23], syscall = signal[23], RW5 = RW, WE5 = WEOut;
    assign WEOut = (signal[20] | signal[15]) & ~signal[23] & ~signal[25], R2DataOut = R2Data;
    mux2 #(16) dut1(aluResult[1], memData[15:0], memData[31:16], lhOneWord);
    mux2 #(32) dut2(signal[6], aluResult, {{16{lhOneWord[15]}}, lhOneWord}, lhOut);
    mux2 #(32) dut3(signal[14], lhOut, memData, lwOut);
    mux2 #(32) dut4(signal[12], lwOut, PC, result5);   
endmodule
