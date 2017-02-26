module opiSim;
    wire [3:0] aluop;
    reg [5:0] op;
    opi dut(op, aluop);
    
    initial
    fork    //op of all I-type instructions are bellow:
        #0 op = 6'b001000;
        #2 op = 6'b001001;
        #4 op = 6'b001100;
        #6 op = 6'b001101;
        #8 op = 6'b100011;
        #10 op = 6'b101011;
        #12 op = 6'b000100;
        #14 op = 6'b000101;
        #16 op = 6'b001010;
        #18 op = 6'b001110;
        #20 op = 6'b100001;
        #22 op = 6'b000001;
    join
endmodule

module oprSim;
    wire [3:0] aluop;
    reg [5:0] func;
    
    opr dut(func, aluop);
    initial
    begin   //func of all R-type instructions are bellow:
        #1 func = 6'b100000;
        #1 func = 6'b100001;
        #1 func = 6'b100010;
        #1 func = 6'b100100;
        #1 func = 6'b100101;
        #1 func = 6'b100111;
        #1 func = 6'b101010;
        #1 func = 6'b101011;
        #1 func = 0;
        #1 func = 2;
        #1 func = 3;
        #1 func = 6'b001000;
        #1 func = 6'b000111;
    end
endmodule

module instSim;
//list all possible op of instructions
    reg [5:0] op;
    wire jal, lw, sw, beq, bne, j, lh, bltz;
    inst dut(op, jal, lw, sw, beq, bne, j, lh, bltz);
    
    initial
    begin
        op = 0;
        #1 op = 6'b001000;
        #1 op = 6'b001001;
        #1 op = 6'b001100;
        #1 op = 6'b001101;
        #1 op = 6'b100011;
        #1 op = 6'b101011;
        #1 op = 6'b000100;
        #1 op = 6'b000101;
        #1 op = 6'b001010;
        #1 op = 6'b001110;
        #1 op = 6'b100001;
        #1 op = 6'b000001;
        #1 op = 2;
        #1 op = 3;
        #1 op = 6'b010000;
    end
endmodule