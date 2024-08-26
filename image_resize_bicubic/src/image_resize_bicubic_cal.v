`timescale 1ns / 1ps

module image_resize_bicubic_cal(
input clk,
input reset,
  
input valid_i,
input [23:0] data0_i,
input [23:0] data1_i,
input [23:0] data2_i,
input [23:0] data3_i,
input [9:0] weight0_i,
input [9:0] weight1_i,
input [9:0] weight2_i,
input [9:0] weight3_i,
   
output valid_o,
output [23:0] data_o
);
 
//³£Á¿ÉùÃ÷
wire [7:0] R0, G0, B0;
wire [7:0] R1, G1, B1;
wire [7:0] R2, G2, B2;
wire [7:0] R3, G3, B3;
wire [17:0] R0_m, G0_m, B0_m;
wire [17:0] R1_m, G1_m, B1_m;
wire [17:0] R2_m, G2_m, B2_m;
wire [17:0] R3_m, G3_m, B3_m;
reg valid_d1;

wire [17:0] R_m, G_m, B_m;
reg [7:0] R, G, B;
reg valid_d2;

assign {R0, G0, B0} = data0_i;
assign {R1, G1, B1} = data1_i;
assign {R2, G2, B2} = data2_i;
assign {R3, G3, B3} = data3_i;

mult_8x10 u_mult_8x10_00 (.CLK(clk), .A(R0), .B(weight0_i), .P(R0_m));
mult_8x10 u_mult_8x10_10 (.CLK(clk), .A(G0), .B(weight0_i), .P(G0_m));
mult_8x10 u_mult_8x10_20 (.CLK(clk), .A(B0), .B(weight0_i), .P(B0_m));

mult_8x10 u_mult_8x10_01 (.CLK(clk), .A(R1), .B(weight1_i), .P(R1_m));
mult_8x10 u_mult_8x10_11 (.CLK(clk), .A(G1), .B(weight1_i), .P(G1_m));
mult_8x10 u_mult_8x10_21 (.CLK(clk), .A(B1), .B(weight1_i), .P(B1_m));

mult_8x10 u_mult_8x10_02 (.CLK(clk), .A(R2), .B(weight2_i), .P(R2_m));
mult_8x10 u_mult_8x10_12 (.CLK(clk), .A(G2), .B(weight2_i), .P(G2_m));
mult_8x10 u_mult_8x10_22 (.CLK(clk), .A(B2), .B(weight2_i), .P(B2_m));

mult_8x10 u_mult_8x10_03 (.CLK(clk), .A(R3), .B(weight3_i), .P(R3_m));
mult_8x10 u_mult_8x10_13 (.CLK(clk), .A(G3), .B(weight3_i), .P(G3_m));
mult_8x10 u_mult_8x10_23 (.CLK(clk), .A(B3), .B(weight3_i), .P(B3_m));

always@(posedge clk) begin
    if(reset) begin
        valid_d1 <= 0;
    end else begin
        valid_d1 <= valid_i;
    end
end

assign R_m = R0_m + R1_m + R2_m + R3_m; 
assign G_m = G0_m + G1_m + G2_m + G3_m; 
assign B_m = B0_m + B1_m + B2_m + B3_m; 

always@(posedge clk) begin
    if(reset) begin
        {R, G, B} <= 0;
        valid_d2 <= 0;
    end else begin
        R <= R_m[17] ? 0 : R_m[16] ? 255 : R_m[15:8];
        G <= G_m[17] ? 0 : G_m[16] ? 255 : G_m[15:8];
        B <= B_m[17] ? 0 : B_m[16] ? 255 : B_m[15:8];
        valid_d2 <= valid_d1;
    end
end

assign valid_o = valid_d2;
assign data_o = {R, G, B};

endmodule
