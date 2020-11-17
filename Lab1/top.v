module LED_7seg(
    input clk,
    output segA, segB, segC, segD, segE, segF, segG, segDP
);

reg [23:0] cnt;
always @(posedge clk) cnt <= cnt+24'h1;
wire cntovf = &cnt;

reg [3:0] BCD_new, BCD_old;
always @(posedge clk) if(cntovf) BCD_new <= (BCD_new==4'h9 ? 4'h0 : BCD_new+4'h1);
always @(posedge clk) if(cntovf) BCD_old <= BCD_new;

reg [4:0] PWM;
wire [3:0] PWM_input = cnt[22:19];
always @(posedge clk) PWM <= PWM[3:0]+PWM_input;
wire [3:0] BCD = (cnt[23] | PWM[4]) ? BCD_new : BCD_old;

reg [7:0] SevenSeg;
always @(*)
case(BCD)
    4'h0: SevenSeg = 8'b11111100;
    4'h1: SevenSeg = 8'b01100000;
    4'h2: SevenSeg = 8'b11011010;
    4'h3: SevenSeg = 8'b11110010;
    4'h4: SevenSeg = 8'b01100110;
    4'h5: SevenSeg = 8'b10110110;
    4'h6: SevenSeg = 8'b10111110;
    4'h7: SevenSeg = 8'b11100000;
    4'h8: SevenSeg = 8'b11111110;
    4'h9: SevenSeg = 8'b11110110;
    4'h10: SevenSeg = 8'b11101100;
    4'h11: SevenSeg = 8'b11111111; // B is different from 8 with DP
    4'h12: SevenSeg = 8'B10011100;
    4'h13: SevenSeg = 8'B11111101; // D is different from 0 with DP
    4'h14: SevenSeg = 8'B10011110;
    4'h15: SevenSeg = 8'B10001110;
    default: SevenSeg = 8'b00000000;
endcase

assign {segA, segB, segC, segD, segE, segF, segG, segDP} = SevenSeg;
endmodule
