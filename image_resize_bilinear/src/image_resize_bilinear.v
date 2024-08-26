`timescale 1ns / 1ps
//delay 2577 clk
module image_resize_bilinear(
input clk,
input reset,

input [11:0] img_width,
input [10:0] img_height,
input up_flag, //0表示缩小，1表示放大
input [3:0] x_scale_factor, //水平方向缩放系数  
input [3:0] y_scale_factor, //垂直方向缩放系数    
  
//ov5640 io
input       frame_clk,
input       frame_ce ,

  
input valid_i,
input [23:0] img_data_i,
output wr_ready,
   
//ov5640 io
output     frame_clk_out,
output     frame_ce_out,
   
output valid_o,
output [23:0] img_data_o
);
 
parameter Delay_cnt = 'd2577; 
 
 
//常量声明
wire rd_en;
wire [10:0] rd_addr;
wire rd_finish, rd_ready;
wire valid;
wire [47:0] cur_line_data;
wire [47:0] next_line_data;
reg [11:0] data_cnt;
reg [10:0] line_cnt;
wire up_line_end_w, down_line_end_w;
wire img_end_w;
reg [3:0] x_cnt;
wire x_end;
reg [3:0] y_cnt;
wire y_end;

reg [8:0] x_scale_factor_recp;
reg [8:0] y_scale_factor_recp;

reg [8:0] dx, dy;
reg [8:0] dx_d, dy_d;
reg [8:0] sub_dx, sub_dy;
wire [23:0] q12, q22, q11, q21;

reg [8:0] dy_d1, sub_dy_d1;
reg [8:0] dy_d2, sub_dy_d2;

wire r_valid;
wire [23:0] r2, r1;
//缓存
image_line_buffer u_image_line_buffer(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .img_width ( img_width ),
    .valid_i   ( valid_i   ),
    .data_i    ( img_data_i),
    .wr_ready  ( wr_ready  ),
    .rd_en     ( rd_en     ),
    .rd_addr   ( rd_addr   ),
    .rd_finish ( rd_finish ),
    .rd_ready  ( rd_ready  ),
    .valid_o   ( valid     ),
    .cur_line_data_o( cur_line_data),
    .next_line_data_o( next_line_data)
);    

assign rd_en = rd_ready&(~up_line_end_w)&(~down_line_end_w);
assign rd_addr = data_cnt;
assign rd_finish = (up_line_end_w&&(y_cnt == y_scale_factor - 1))||down_line_end_w ? 1 : 0;

////////////////////读取地址
//最近邻插值抽点以及抽行处理，计数逻辑
always@(posedge clk) begin
    if(reset) begin
        x_cnt <= 0;
        y_cnt <= 0;
    end else if(up_flag) begin
        x_cnt <= x_end||up_line_end_w ? 0 : rd_en ? (x_cnt + 1) : x_cnt;
        y_cnt <= y_end ? 0 : up_line_end_w ? (y_cnt + 1) : y_cnt;
    end else begin
        x_cnt <= 0;
        y_cnt <= y_end ? 0 : down_line_end_w ? (y_cnt + 1) : y_cnt;
    end
end

assign x_end = (x_cnt == x_scale_factor - 1) ? 1 : 0;
assign y_end = (up_line_end_w||down_line_end_w)&&(y_cnt == y_scale_factor - 1) ? 1 : 0;


//数据计数，一行数据长度，以及当前行号
always@(posedge clk) begin
    if(reset) begin
        data_cnt <= 0;
        line_cnt <= 0;
    end else if(up_flag) begin
        data_cnt <= up_line_end_w ? 0 : x_end ? (data_cnt + 1) : data_cnt;
        line_cnt <= img_end_w ? 0 : y_end ? (line_cnt + 1) : line_cnt;
    end else begin
        data_cnt <= down_line_end_w ? 0 : rd_en ? (data_cnt + x_scale_factor) : data_cnt;
        line_cnt <= img_end_w ? 0 : rd_finish ? (line_cnt + 1) : line_cnt;
    end
end

//从0开始计数，计数数据长度等于img_width时，一行结束，且这时不读取数据
assign up_line_end_w = (data_cnt == img_width) ? 1 : 0;
//从0开始计数，计数数据长度大于img_width时，一行结束，且这时不读取数据；如果当前行，不是选中的行（y_cnt大于0），则需要直接清0
assign down_line_end_w = ((data_cnt > img_width)||(rd_ready&&(y_cnt > 0)))&&(~up_flag) ? 1 : 0;
assign img_end_w = y_end&&(line_cnt == img_height - 1) ? 1 : 0;

////////////////////插值运算
//扩大了8bit
always@(posedge clk) begin
    if(reset) begin
        x_scale_factor_recp <= 0;
        y_scale_factor_recp <= 0;
    end else if(up_flag) begin //权重设置   x_cnt/x_scale_factor      y_cnt/y_scale_factor
        case(x_scale_factor)
        0: x_scale_factor_recp <= 0;
        1: x_scale_factor_recp <= 256;
        2: x_scale_factor_recp <= 128;
        3: x_scale_factor_recp <= 85;
        4: x_scale_factor_recp <= 64;
        5: x_scale_factor_recp <= 51;
        6: x_scale_factor_recp <= 43;
        7: x_scale_factor_recp <= 37;
        8: x_scale_factor_recp <= 32;
        9: x_scale_factor_recp <= 28;
        10: x_scale_factor_recp <= 26;
        11: x_scale_factor_recp <= 23;
        12: x_scale_factor_recp <= 21;
        13: x_scale_factor_recp <= 20;
        14: x_scale_factor_recp <= 18;
        15: x_scale_factor_recp <= 17;
        endcase
        case(y_scale_factor)
        0: y_scale_factor_recp <= 0;
        1: y_scale_factor_recp <= 256;
        2: y_scale_factor_recp <= 128;
        3: y_scale_factor_recp <= 85;
        4: y_scale_factor_recp <= 64;
        5: y_scale_factor_recp <= 51;
        6: y_scale_factor_recp <= 43;
        7: y_scale_factor_recp <= 37;
        8: y_scale_factor_recp <= 32;
        9: y_scale_factor_recp <= 28;
        10: y_scale_factor_recp <= 26;
        11: y_scale_factor_recp <= 23;
        12: y_scale_factor_recp <= 21;
        13: y_scale_factor_recp <= 20;
        14: y_scale_factor_recp <= 18;
        15: y_scale_factor_recp <= 17;
        endcase
    end else begin //整数倍缩放时，权重都为0
        x_scale_factor_recp <= 0;
        y_scale_factor_recp <= 0;
    end
end

//权重计算，扩大了8bit
always@(posedge clk) begin
    if(reset) begin
        dx <= 0;
        dy <= 0;
    end else begin
        dx <= x_cnt * x_scale_factor_recp;
        dy <= y_cnt * y_scale_factor_recp;
    end
end

always@(posedge clk) begin
    if(reset) begin
        dx_d <= 0;
        dy_d <= 0;
        sub_dx <= 0;
        sub_dy <= 0;
    end else begin
        dx_d <= dx;
        dy_d <= dy;
        sub_dx <= 256 - dx;
        sub_dy <= 256 - dy;
    end
end

assign {q12, q22} = cur_line_data;
assign {q11, q21} = next_line_data;

//水平方向
image_resize_bilinear_cal u_image_resize_bilinear_cal0(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( valid     ),
    .data0_i   ( q12       ),
    .data1_i   ( q22       ),
    .weight0_i ( sub_dx    ),
    .weight1_i ( dx_d      ),
    .valid_o   ( r_valid   ),
    .data_o    ( r2        )
);

image_resize_bilinear_cal u_image_resize_bilinear_cal1(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( valid     ),
    .data0_i   ( q11       ),
    .data1_i   ( q21       ),
    .weight0_i ( sub_dx    ),
    .weight1_i ( dx_d      ),
    .valid_o   (           ),
    .data_o    ( r1        )
);

always@(posedge clk) begin
    if(reset) begin
        {dy_d1, sub_dy_d1} <= 0;
        {dy_d2, sub_dy_d2} <= 0;
    end else begin
        {dy_d1, sub_dy_d1} <= {dy_d, sub_dy};
        {dy_d2, sub_dy_d2} <= {dy_d1, sub_dy_d1};
    end
end

//垂直方向
image_resize_bilinear_cal u_image_resize_bilinear_cal2(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( r_valid   ),
    .data0_i   ( r2        ),
    .data1_i   ( r1        ),
    .weight0_i ( sub_dy_d2 ),
    .weight1_i ( dy_d2     ),
    .valid_o   ( valid_o   ),
    .data_o    ( img_data_o)
);

wire rd_en_delay1;
wire rd_en_delay2;
wire [12:0]  fifo_data_count1;
wire [12:0]  fifo_data_count2;

assign rd_en_delay1 =  (fifo_data_count1 >= Delay_cnt)?1'b1:1'b0;
assign rd_en_delay2 =  (fifo_data_count2 >= Delay_cnt)?1'b1:1'b0;


fifo_delay fifo_delay_inst1
 (
  .clk          (clk              ),                // input wire clk
  .srst         (reset            ),              // input wire srst
  .din          (frame_clk        ),                // input wire [0 : 0] din
  .wr_en        (1'b1             ),            // input wire wr_en
  .rd_en        (rd_en_delay1     ),            // input wire rd_en
  .dout         (frame_clk_out    ),              // output wire [0 : 0] dout
  .full         (                 ),              // output wire full
  .empty        (                 ),            // output wire empty
  .data_count   (fifo_data_count1 )  // output wire [10 : 0] data_count
);    


fifo_delay fifo_delay_inst2
 (
  .clk          (clk              ),                // input wire clk
  .srst         (reset            ),              // input wire srst
  .din          (frame_ce         ),                // input wire [0 : 0] din
  .wr_en        (1'b1             ),            // input wire wr_en
  .rd_en        (rd_en_delay2     ),            // input wire rd_en
  .dout         (frame_ce_out     ),              // output wire [0 : 0] dout
  .full         (                 ),              // output wire full
  .empty        (                 ),            // output wire empty
  .data_count   (fifo_data_count2 )  // output wire [10 : 0] data_count
);    


endmodule
