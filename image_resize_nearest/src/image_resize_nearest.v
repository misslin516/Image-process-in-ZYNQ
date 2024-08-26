`timescale 1ns / 1ps

module image_resize_nearest(
    input clk,
    input reset,

    input [11:0] img_width,
    input [10:0] img_height,
    input up_flag, //0表示缩小，1表示放大
    input [3:0] x_scale_factor, //横向缩放系数  
    input [3:0] y_scale_factor, //纵向缩放系数

    //ov5640 related io
    input   frame_clk_in,
    input   frame_ce_in,
       
    input valid_i,
    input [23:0] img_data_i,
    
    //ov5640 related io 
    output   frame_clk_out,
    output   frame_ce_out,
    
    output wr_ready,
       
    output valid_o,
    output [23:0] img_data_o
);//delay 1284clk
 
 
parameter Delay_para =  'd1284;
//常量声明
wire rd_en;
wire [10:0] rd_addr;
wire rd_finish, rd_ready;
reg [11:0] data_cnt;
reg [10:0] line_cnt;
wire up_line_end_w, down_line_end_w;
wire img_end_w;
reg [3:0] x_cnt;
wire x_end;
reg [3:0] y_cnt;
wire y_end;

reg valid;
reg [24:0] img_data;

//缓存
image_line_buffer u_image_line_buffer(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .img_width ( img_width ),
    .valid_i   ( valid_i   ),
    .data_i    ( img_data_i),
    .wr_ready  ( wr_ready  ),//
    .rd_en     ( rd_en     ),
    .rd_addr   ( rd_addr   ),
    .rd_finish ( rd_finish ),
    .rd_ready  ( rd_ready  ),//
    .valid_o   ( valid_o   ),//
    .data_o    ( img_data_o)//
);    

assign rd_en = rd_ready&(~up_line_end_w)&(~down_line_end_w);
assign rd_addr = data_cnt;
assign rd_finish = (up_line_end_w&&(y_cnt == y_scale_factor - 1))||down_line_end_w ? 1 : 0;
//前半部分(up_line_end_w&&(y_cnt == y_scale_factor - 1))该信号控制多次行读和多次列读
//后半部分down_line_end_w该信号控制跳读

//最近邻插值抽点以及抽行处理，计数逻辑
always@(posedge clk) begin
    if(reset) begin
        x_cnt <= 0;
        y_cnt <= 0;
    end else if(up_flag) begin  //放大
        x_cnt <= x_end||up_line_end_w ? 0 : rd_en ? (x_cnt + 1) : x_cnt;
        y_cnt <= y_end ? 0 : up_line_end_w ? (y_cnt + 1) : y_cnt;
    end else begin//缩小
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
    end else if(up_flag) begin//放大
        data_cnt <= up_line_end_w ? 0 : x_end ? (data_cnt + 1) : data_cnt;
        line_cnt <= img_end_w ? 0 : y_end ? (line_cnt + 1) : line_cnt;
    end else begin//缩小
        data_cnt <= down_line_end_w ? 0 : rd_en ? (data_cnt + x_scale_factor) : data_cnt;
        line_cnt <= img_end_w ? 0 : rd_finish ? (line_cnt + 1) : line_cnt;
    end
end

//从0开始计数，计数数据长度等于img_width时，一行结束，且这时不读取数据
assign up_line_end_w = (data_cnt == img_width) ? 1 : 0;
//从0开始计数，计数数据长度大于img_width时，一行结束，且这时不读取数据；如果当前行，不是选中的行（y_cnt大于0），则需要直接清0
assign down_line_end_w = ((data_cnt > img_width)||(rd_ready&&(y_cnt > 0)))&&(~up_flag) ? 1 : 0;
assign img_end_w = y_end&&(line_cnt == img_height - 1) ? 1 : 0;

wire rd_en_delay1;
wire rd_en_delay2;

wire [10:0] fifo_data_count1;
wire [10:0] fifo_data_count2;

assign rd_en_delay1 = (fifo_data_count1 >= Delay_para)?1'b1:1'b0;
assign rd_en_delay2 = (fifo_data_count2 >= Delay_para)?1'b1:1'b0;


fifo_delay fifo_delay_inst1
 (
  .clk          (clk              ),                // input wire clk
  .srst         (reset            ),              // input wire srst
  .din          (frame_clk_in     ),                // input wire [0 : 0] din
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
  .din          (frame_ce_in      ),                // input wire [0: 0] din
  .wr_en        (1'b1             ),            // input wire wr_en
  .rd_en        (rd_en_delay2     ),            // input wire rd_en
  .dout         (frame_ce_out     ),              // output wire [0: 0] dout
  .full         (                 ),              // output wire full
  .empty        (                 ),            // output wire empty
  .data_count   (fifo_data_count2 )  // output wire [10 : 0] data_count
);  



endmodule
