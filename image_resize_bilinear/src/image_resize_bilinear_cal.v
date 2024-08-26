`timescale 1ns / 1ps

module image_resize_bilinear_cal(
input clk,
input reset,
  
input valid_i,
input [23:0] data0_i,
input [23:0] data1_i,
input [8:0] weight0_i,
input [8:0] weight1_i,
   
output valid_o,
output [23:0] data_o
);
 
//³£Á¿ÉùÃ÷
wire [7:0] R0, G0, B0;
wire [7:0] R1, G1, B1;
reg [16:0] R0_m, G0_m, B0_m;
reg [16:0] R1_m, G1_m, B1_m;
reg valid_d1;

wire [15:0] R_m, G_m, B_m;
reg [7:0] R, G, B;
reg valid_d2;

assign {R0, G0, B0} = data0_i;
assign {R1, G1, B1} = data1_i;
always@(posedge clk) begin
    if(reset) begin
        {R0_m, G0_m, B0_m} <= 0;
        {R1_m, G1_m, B1_m} <= 0;
        valid_d1 <= 0;
    end else begin
        R0_m <= R0*weight0_i;
        G0_m <= G0*weight0_i;
        B0_m <= B0*weight0_i;
        R1_m <= R1*weight1_i;
        G1_m <= G1*weight1_i;
        B1_m <= B1*weight1_i;
        valid_d1 <= valid_i;
    end
end

assign R_m = R0_m + R1_m; 
assign G_m = G0_m + G1_m; 
assign B_m = B0_m + B1_m; 

always@(posedge clk) begin
    if(reset) begin
        {R, G, B} <= 0;
        valid_d2 <= 0;
    end else begin
        R <= R_m[15:8];
        G <= G_m[15:8];
        B <= B_m[15:8];
        valid_d2 <= valid_d1;
    end
end

assign valid_o = valid_d2;
assign data_o = {R, G, B};

endmodule
