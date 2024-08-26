//created by martin
//careted date:2024/7/6
module rgbtoyuv
(
//sys
    input           sys_clk              ,
    input           rst_n                ,
//coms io   //followed by the cmos IO                           
    input           frame_clk            ,   // vsync
    input           frame_clk_en         ,
    input           frame_data_en        ,
    input   [23:0]  frame_data           ,

    output          frame_clk_out        ,   // vsync
    output          frame_clk_en_out     ,
    output          frame_data_en_out    ,
    output   [23:0] frame_data_out

);




//相应的公式
/********************************************************
RGB888 to YCbCr
Y = 0.299R +0.587G + 0.114B
Cb = -0.169R-0.331G + 0.5B + 128
CR = 0.5R-0.419G -0.081B + 128

Y = (77 *R + 150*G + 29 *B)>>8
Cb = (-43*R - 85 *G + 128*B)>>8 + 128
Cr = (128*R - 107*G - 21 *B)>>8 + 128

Y = (77 *R + 150*G + 29 *B )>>8
Cb = (-43*R - 85 *G + 128*B + 32768)>>8
Cr = (128*R - 107*G - 21 *B + 32768)>>8
*********************************************************/
//there is no negative number following the computation above,so we just need define the unsigned reg
/********************************wire**********************************/
wire [7:0] R;
wire [7:0] G;
wire [7:0] B;

/********************************reg**********************************/
reg [15:0] R_reg_y ;
reg [15:0] G_reg_y ;
reg [15:0] B_reg_y ;
   
reg [15:0] R_reg_cb;
reg [15:0] G_reg_cb;
reg [15:0] B_reg_cb;
   
reg [15:0] R_reg_cr;
reg [15:0] G_reg_cr;
reg [15:0] B_reg_cr;

reg [15:0] Y;
reg [15:0] Cb;
reg [15:0] Cr;

reg [7:0] Y_scaled ;
reg [7:0] Cb_scaled;
reg [7:0] Cr_scaled;

reg [2:0] frame_clk_reg0        ;
reg [2:0] frame_data_en_reg0    ;
reg [2:0] frame_clk_en_reg0     ;

/********************************assign**********************************/
assign R = frame_data[23:16];
assign G = frame_data[15:8];
assign B = frame_data[7:0];

assign frame_data_out = frame_clk_en_out ? {Y_scaled,Cb_scaled,Cr_scaled}:'d0;
assign frame_clk_out = frame_clk_reg0[2];
assign frame_clk_en_out = frame_clk_en_reg0[2];
assign frame_data_en_out = frame_data_en_reg0[2];
/********************************always**********************************/

always@(posedge sys_clk)
begin
    if(~rst_n)begin
        R_reg_y   <= 'd0 ;
        G_reg_y   <= 'd0 ;
        B_reg_y   <= 'd0 ;
                  
        R_reg_cb  <= 'd0 ;
        G_reg_cb  <= 'd0 ;
        B_reg_cb  <= 'd0 ;
                   
        R_reg_cr  <= 'd0 ;
        G_reg_cr  <= 'd0 ;
        B_reg_cr  <= 'd0 ;
    end else begin // note :this is unsigned
        R_reg_y   <= 77 * R;
        G_reg_y   <= 150* G;
        B_reg_y   <= 29 * B;
                  
        R_reg_cb  <= 43 * R ;
        G_reg_cb  <= 85 * G ;
        B_reg_cb  <= 128* B ;
                   
        R_reg_cr  <= 128 * R;
        G_reg_cr  <= 107 * G;
        B_reg_cr  <= 21  * B;
    end
end

always@(posedge sys_clk)
begin
    if(~rst_n)begin
        Y <= 'd0;
        Cb <= 'd0;
        Cr <= 'd0;
    end else begin
        Y <= R_reg_y + G_reg_y + B_reg_y;
        Cb <= B_reg_cb - G_reg_cb - R_reg_cb + 'd32768;
        Cr <= R_reg_cr - G_reg_cr - B_reg_cr + 'd32768;
    end
end


always@(posedge sys_clk)
begin
    if(~rst_n)begin
        Y_scaled  <= 'd0;
        Cb_scaled <= 'd0;
        Cr_scaled <= 'd0;
    end else begin
        Y_scaled  <= Y[15:8];
        Cb_scaled <= Cb[15:8] ;
        Cr_scaled <= Cr[15:8] ;
    end
end

//delay three clock
always@(posedge sys_clk)
begin
    if(~rst_n)begin
        frame_clk_reg0     <= 'd0;
        frame_data_en_reg0 <= 'd0;
        frame_clk_en_reg0  <= 'd0;
    end else begin
        frame_clk_reg0     <= {frame_clk_reg0[1:0],frame_clk};
        frame_data_en_reg0 <= {frame_data_en_reg0[1:0],frame_data_en};
        frame_clk_en_reg0  <= {frame_clk_en_reg0[1:0],frame_clk_en};
    end
end



endmodule
