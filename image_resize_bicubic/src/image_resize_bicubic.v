`timescale 1ns / 1ps


module image_resize_bicubic(
input clk,
input reset,

input [11:0] img_width,
input [10:0] img_height,
input up_flag, //0表示缩小，1表示放大
input [3:0] x_scale_factor, //水平方向缩放系数  
input [3:0] y_scale_factor, //垂直方向缩放系数    
   
input valid_i,
input [23:0] img_data_i,
output wr_ready,
   
output valid_o,
output [23:0] img_data_o
);
 
//常量声明
wire rd_en;
wire [10:0] rd_addr;
wire rd_finish, rd_ready;
wire valid;
wire [24*4-1:0] prev_line_data;
wire [24*4-1:0] cur_line_data;
wire [24*4-1:0] next_line1_data;
wire [24*4-1:0] next_line2_data;
reg [11:0] data_cnt;
reg [10:0] line_cnt;
wire up_line_end_w, down_line_end_w;
wire img_end_w;
reg [3:0] x_cnt;
wire x_end;
reg [3:0] y_cnt;
wire y_end;
reg [11:0] data_cnt_d1, data_cnt_d2;
reg [10:0] line_cnt_d1, line_cnt_d2;
wire [24*4-1:0] prev_line_data_s;
wire [24*4-1:0] cur_line_data_s;
wire [24*4-1:0] next_line1_data_s;
wire [24*4-1:0] next_line2_data_s;
reg valid_d;
reg [24*4-1:0] prev_line_data_d;
reg [24*4-1:0] cur_line_data_d;
reg [24*4-1:0] next_line1_data_d;
reg [24*4-1:0] next_line2_data_d;

reg [8:0] x_scale_factor_recp;
reg [8:0] y_scale_factor_recp;

reg rd_en_d1;
reg [8:0] dx, dy;

reg rd_en_d2;
reg [8:0] dx_d, dy_d;

reg rd_en_d3;
reg [8:0] dy_d1;
wire [9:0] x_w0, x_w1, x_w2, x_w3;
wire [23:0] q00, q01, q02, q03;
wire [23:0] q10, q11, q12, q13;
wire [23:0] q20, q21, q22, q23;
wire [23:0] q30, q31, q32, q33;

reg rd_en_d4;
reg [8:0] dy_d2;

wire [9:0] y_w0, y_w1, y_w2, y_w3;

wire r_valid;
wire [23:0] r0, r1, r2, r3;
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
    .prev_line_data_o( prev_line_data),
    .cur_line_data_o( cur_line_data),
    .next_line1_data_o( next_line1_data),
    .next_line2_data_o( next_line2_data)
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

always@(posedge clk) begin
    if(reset) begin
        {line_cnt_d1, line_cnt_d2} <= 0;
        {data_cnt_d1, data_cnt_d2} <= 0;
    end else begin
        line_cnt_d1 <= line_cnt;
        line_cnt_d2 <= line_cnt_d1;
        data_cnt_d1 <= data_cnt;
        data_cnt_d2 <= data_cnt_d1;
    end
end

//边界数据处理
assign prev_line_data_s = (data_cnt_d2 == 0) ? {prev_line_data[24*3-1:24*2], prev_line_data[24*3-1:0]} : 
                         (data_cnt_d2 == img_width-2) ? {prev_line_data[24*4-1:24*1], prev_line_data[24*2-1:24]} : 
                         (data_cnt_d2 == img_width-1) ? {prev_line_data[24*4-1:24*2], prev_line_data[24*3-1:24*2]} : prev_line_data;
assign cur_line_data_s = (data_cnt_d2 == 0) ? {cur_line_data[24*3-1:24*2], cur_line_data[24*3-1:0]} : 
                         (data_cnt_d2 == img_width-2) ? {cur_line_data[24*4-1:24*1], cur_line_data[24*2-1:24]} : 
                         (data_cnt_d2 == img_width-1) ? {cur_line_data[24*4-1:24*2], cur_line_data[24*3-1:24*2]} : cur_line_data;
assign next_line1_data_s = (data_cnt_d2 == 0) ? {next_line1_data[24*3-1:24*2], next_line1_data[24*3-1:0]} : 
                         (data_cnt_d2 == img_width-2) ? {next_line1_data[24*4-1:24*1], next_line1_data[24*2-1:24]} : 
                         (data_cnt_d2 == img_width-1) ? {next_line1_data[24*4-1:24*2], next_line1_data[24*3-1:24*2]} : next_line1_data; 
assign next_line2_data_s = (data_cnt_d2 == 0) ? {next_line2_data[24*3-1:24*2], next_line2_data[24*3-1:0]} : 
                         (data_cnt_d2 == img_width-2) ? {next_line2_data[24*4-1:24*1], next_line2_data[24*2-1:24]} : 
                         (data_cnt_d2 == img_width-1) ? {next_line2_data[24*4-1:24*2], next_line2_data[24*3-1:24*2]} : next_line2_data;                        
always@(posedge clk) begin
    if(reset) begin
        valid_d <= 0;
        prev_line_data_d <= 0;
        cur_line_data_d <= 0;
        next_line1_data_d <= 0;
        next_line2_data_d <= 0;
    end else begin
        valid_d <= valid;
        if(line_cnt_d2 == 0) begin
            prev_line_data_d <= cur_line_data_s;
            cur_line_data_d <= cur_line_data_s;
            next_line1_data_d <= next_line1_data_s;
            next_line2_data_d <= next_line2_data_s;
        end else if(line_cnt_d2 == img_height-2) begin
            prev_line_data_d <= prev_line_data_s;
            cur_line_data_d <= cur_line_data_s;
            next_line1_data_d <= next_line1_data_s;
            next_line2_data_d <= next_line1_data_s;
        end else if(line_cnt_d2 == img_height-1) begin
            prev_line_data_d <= prev_line_data_s;
            cur_line_data_d <= cur_line_data_s;
            next_line1_data_d <= cur_line_data_s;
            next_line2_data_d <= cur_line_data_s;
        end else begin
            prev_line_data_d <= prev_line_data_s;
            cur_line_data_d <= cur_line_data_s;
            next_line1_data_d <= next_line1_data_s;
            next_line2_data_d <= next_line2_data_s;
        end
    end
end

////////////////////插值运算
//扩大了8bit
always@(posedge clk) begin
    if(reset) begin
        x_scale_factor_recp <= 0;
        y_scale_factor_recp <= 0;
    end else if(up_flag) begin
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
        rd_en_d1 <= 0;
        dx <= 0;
        dy <= 0;
    end else begin
        rd_en_d1 <= rd_en;
        dx <= x_cnt * x_scale_factor_recp;
        dy <= y_cnt * y_scale_factor_recp;
    end
end

always@(posedge clk) begin
    if(reset) begin
        rd_en_d2 <= 0;
        dx_d <= 0;
        dy_d <= 0;
    end else begin
        rd_en_d2 <= rd_en_d1;
        dx_d <= dx;
        dy_d <= dy;
    end
end

//根据权重核计算函数，计算权重
kernel_table u_kernel_table0(
    .clk   ( clk   ),
    .rd_en ( rd_en_d2 ),
    .addr  ( dx_d  ),
    .dout0 ( x_w0 ),
    .dout1 ( x_w1 ),
    .dout2 ( x_w2 ),
    .dout3 ( x_w3 )
);

always@(posedge clk) begin
    if(reset) begin
        rd_en_d3 <= 0;
        dy_d1 <= 0;
    end else begin
        rd_en_d3 <= rd_en_d2;
        dy_d1 <= dy_d;
    end
end


assign {q00, q01, q02, q03} = prev_line_data_d;
assign {q10, q11, q12, q13} = cur_line_data_d;
assign {q20, q21, q22, q23} = next_line1_data_d;
assign {q30, q31, q32, q33} = next_line2_data_d;

//水平方向
image_resize_bicubic_cal u_image_resize_bicubic_cal0(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( valid_d   ),
    .data0_i   ( q00       ),
    .data1_i   ( q01       ),
    .data2_i   ( q02       ),
    .data3_i   ( q03       ),
    .weight0_i ( x_w0      ),
    .weight1_i ( x_w1      ),
    .weight2_i ( x_w2      ),
    .weight3_i ( x_w3      ),
    .valid_o   ( r_valid   ),
    .data_o    ( r0        )
);

image_resize_bicubic_cal u_image_resize_bicubic_cal1(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( valid_d   ),
    .data0_i   ( q10       ),
    .data1_i   ( q11       ),
    .data2_i   ( q12       ),
    .data3_i   ( q13       ),
    .weight0_i ( x_w0      ),
    .weight1_i ( x_w1      ),
    .weight2_i ( x_w2      ),
    .weight3_i ( x_w3      ),
    .valid_o   (           ),
    .data_o    ( r1        )
);

image_resize_bicubic_cal u_image_resize_bicubic_cal2(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( valid_d   ),
    .data0_i   ( q20       ),
    .data1_i   ( q21       ),
    .data2_i   ( q22       ),
    .data3_i   ( q23       ),
    .weight0_i ( x_w0      ),
    .weight1_i ( x_w1      ),
    .weight2_i ( x_w2      ),
    .weight3_i ( x_w3      ),
    .valid_o   (           ),
    .data_o    ( r2        )
);

image_resize_bicubic_cal u_image_resize_bicubic_cal3(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( valid_d   ),
    .data0_i   ( q30       ),
    .data1_i   ( q31       ),
    .data2_i   ( q32       ),
    .data3_i   ( q33       ),
    .weight0_i ( x_w0      ),
    .weight1_i ( x_w1      ),
    .weight2_i ( x_w2      ),
    .weight3_i ( x_w3      ),
    .valid_o   (           ),
    .data_o    ( r3        )
);

always@(posedge clk) begin
    if(reset) begin
        rd_en_d4 <= 0;
        dy_d2 <= 0;
    end else begin
        rd_en_d4 <= rd_en_d3;
        dy_d2 <= dy_d1;
    end
end

//根据权重核计算函数，计算权重
kernel_table u_kernel_table1(
    .clk   ( clk   ),
    .rd_en ( rd_en_d4 ),
    .addr  ( dy_d2  ),
    .dout0 ( y_w0 ),
    .dout1 ( y_w1 ),
    .dout2 ( y_w2 ),
    .dout3 ( y_w3 )
);

//垂直方向
image_resize_bicubic_cal u_image_resize_bicubic_cal4(
    .clk       ( clk       ),
    .reset     ( reset     ),
    .valid_i   ( r_valid   ),
    .data0_i   ( r0        ),
    .data1_i   ( r1        ),
    .data2_i   ( r2        ),
    .data3_i   ( r3        ),
    .weight0_i ( y_w0      ),
    .weight1_i ( y_w1      ),
    .weight2_i ( y_w2      ),
    .weight3_i ( y_w3      ),
    .valid_o   ( valid_o   ),
    .data_o    ( img_data_o)
);

endmodule
