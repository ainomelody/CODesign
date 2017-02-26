module decoder(
    input [3 : 0] num,
    output reg [7 : 0] cathnodes
);
    always @(num)
        case(num)
            0: cathnodes = 8'b00000011;
            1: cathnodes = 8'b10011111;
            2: cathnodes = 8'b00100101;
            3: cathnodes = 8'b00001101;
            4: cathnodes = 8'b10011001;
            5: cathnodes = 8'b01001001;
            6: cathnodes = 8'b01000001;
            7: cathnodes = 8'b00011111;
            8: cathnodes = 8'b00000001;
            9: cathnodes = 8'b00001001;
            10: cathnodes = 8'b00010001;
            11: cathnodes = 8'b11000001;
            12: cathnodes = 8'b01100011;
            13: cathnodes = 8'b10000101;
            14: cathnodes = 8'b01100001;
            15: cathnodes = 8'b01110001;
        endcase
endmodule

module freqDiv(cp, stop, pulse);  //≤‚ ‘Õ®π˝
parameter NUM = 10000;
parameter N = 9;

input cp;
reg [N - 1 : 0] numCount;
input stop;
output reg pulse;

always @(posedge cp)
begin
    if (~stop)
        numCount = numCount + 1;
    if (numCount == NUM)
    begin
        pulse = ~pulse;
        numCount = 0;
    end
end
endmodule

module display(
    input cp,
    input [7 : 0]num0, input [7 : 0]num1, input [7 : 0]num2, input [7 : 0]num3,
    input [7 : 0]num4, input [7 : 0]num5, input [7 : 0]num6, input [7 : 0]num7,
    output reg [7 : 0]anodes,
    output reg [7 : 0]cathnodes
);

    wire outCP;
    reg [2 : 0] num;
    
    freqDiv #(100000, 17) dut(cp, 0, outCP);
    
    always @(posedge outCP)
    begin
        num = num + 1;
        case (num)
            0: begin anodes = 8'b11111110; cathnodes = num0; end
            1: begin anodes = 8'b11111101; cathnodes = num1; end
            2: begin anodes = 8'b11111011; cathnodes = num2; end
            3: begin anodes = 8'b11110111; cathnodes = num3; end
            4: begin anodes = 8'b11101111; cathnodes = num4; end
            5: begin anodes = 8'b11011111; cathnodes = num5; end
            6: begin anodes = 8'b10111111; cathnodes = num6; end
            7: begin anodes = 8'b01111111; cathnodes = num7; end
        endcase
    end
endmodule