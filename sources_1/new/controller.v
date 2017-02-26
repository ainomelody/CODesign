`timescale 1ns / 1ps

module controller(
    input [5:0] op, input [5:0] func,
    output [3:0] AluOP, output lh, output bltz, output isRshift, output PCjump, output beq, output bne,
    output jal, output [1:0] aluy, output sw, output lw, output WE, output srav, output jr, output R
);
    wire j;
    wire [3:0] opiResult, oprResult;
    
    inst dut1(op, jal, lw, sw, beq, bne, j, lh, bltz);
    aluyMux dut2(op, aluy);
    opi dut3(op, opiResult);
    opr dut4(func, oprResult);
    mux2 #(4) dut5(R, opiResult, oprResult, AluOP);
    
    assign PCjump = j | jal;
    assign R = ~(op[5] | op[4] | op[3] | op[2] | op[1] | op[0]);
    assign isRshift = R & ~func[5];
    assign jr = R & ~(func[5] | func[4] | ~func[3] | func[2] | func[1] | func[0]);
    assign WE = ~(bltz | jr | j | bne | beq | sw);
    assign srav = ~func[5] & ~func[4] & ~func[3] & func[2] & func[1] & func[0] & R; 
endmodule

module opi(
    input [5:0] op,
    output [3:0] alu
);
    assign alu[3] = ~op[3] & ~op[0] | op[1] & ~op[0] | op[2] & op[0];
    assign alu[2] = ~op[2] & op[0] | op[3] & ~op[1] & ~op[0];
    assign alu[1] = ~op[2] & op[1] & ~op[0] | ~op[3] & op[2] | op[2] & ~op[1] & ~op[0];
    assign alu[0] = ~op[3] | ~op[2] | ~op[0];
endmodule

module opr(
    input [5:0]func,
    output [3:0] alu
);
    assign alu[3] = func[3] | func[5] & func[2] & func[0];
    assign alu[2] = func[2] & ~func[0] | func[3] & func[0] | func[5] & ~func[3] & ~func[2];
    assign alu[1] = func[1] & ~func[0] | func[2] & ~func[0] | func[5] & ~func[3] & func[1];
    assign alu[0] = ~func[5] & func[0] | func[2] & ~func[0] | func[3] & ~func[0] | func[5] & ~func[2] & ~func[1];
endmodule

module inst(
    input [5:0]op,
    output jal, output lw, output sw, output beq, output bne, output j, output lh, output bltz
);
    assign jal = ~op[5] & op[1] & op[0];
    assign lw = op[5] & ~op[3] & ~op[0] | op[5] & ~op[3] & op[1] | op[5] & ~op[3] & op[2] | op[5] & op[4] & ~op[3];
    assign sw = op[5] & op[3];
    assign beq = ~op[3] & op[2] & ~op[0];
    assign bne = ~op[3] & op[2] & ~op[1] & op[0] | op[4] & ~op[3] & ~op[1] & op[0];
    assign j = ~op[3] & op[1] & ~op[0];
    assign lh = op[5] & ~op[1];
    assign bltz = ~op[5] & ~op[3] & ~op[2] & ~op[1] & op[0];
endmodule

module aluyMux(
    input [5:0] op,
    output [1:0] num
);
    assign num[1] = ~op[5] & ~op[3];
    assign num[0] = ~op[3] & ~op[2] | ~op[2] & ~op[0] | op[5];
endmodule