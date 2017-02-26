`timescale 1ns / 1ps

module alu(
    input [31:0] x,
    input [31:0] y,
    input [3:0] AluOP,
    output reg [31:0] result,
    output equal
    );
    assign equal = (x == y);
    always @(x or y or AluOP)
    begin
        case(AluOP)
            0: result = x << y[4:0];
            1: result = x >>> y[4:0];
            2: result = x >> y[4:0];
            3: result = x * y;
            4: result = x / y;
            5: result = x + y;
            6: result = x - y;
            7: result = x & y;
            8: result = x | y;
            9: result = x ^ y;
            10: result = ~(x | y);
            11: result = $signed(x) < $signed(y);
            12: result = x < y;
        endcase
    end
endmodule
