`timescale 1ns / 1ps

module image_line_buffer(
input wire clk,
input wire reset,

input wire [10:0] img_width,
input wire [9:0] img_height,

input wire valid_i,
input wire [7:0] img_data_i,

output reg valid_o,
output reg [7:0] prev_line_data_o,
output reg [7:0] cur_line_data_o,
output reg [7:0] next_line_data_o
);
    
//常量声明
parameter N = 3; //窗口大小

//变量声明
genvar i;
integer j;
wire [0:0] valid [0:N-1];
wire [23:0] data [0:N-1];

reg [10:0] out_data_cnt;
reg [9:0] out_line_cnt;
reg ch_valid;
reg [7:0] ch_data [0:N-1];

assign valid[0] = valid_i;
assign data[0] = img_data_i;

//行缓存模块, 只需要缓存N-1个fifo即可
generate for(i=1;i<N;i=i+1)
begin:lb

line_buffer u_line_buffer(
.clk       ( clk       ),
.reset     ( reset     ),
.img_width ( img_width ),
.valid_i   ( valid[i-1]   ),
.data_i    ( data[i-1]    ),
.valid_o   ( valid[i]   ),
.data_o    ( data[i]    )
);           
end        
endgenerate

//模式1，按照上一行、当前行、下一行输出
//特殊情况，可根据需求设定，是复制还是给0
//第1个行缓存，是整个画面的第1行时， 上一行数据不存在，复制第1个行缓存或者直接为0输出
//第1个行缓存，是整个画面的最后1行时，下一行数据不存在，复制第1个行缓存输出
always@(posedge clk) begin
    if(reset) begin
        for(j=0;j<3;j=j+1)
            ch_data[j] <= 0;
    end else if(valid[N-2]) begin
        ch_data[1] <= data[1];
        if(out_line_cnt == 0) begin
            ch_data[2] <= 0;
            ch_data[0] <= data[0];
        end else if(out_line_cnt == img_height -1) begin
            ch_data[2] <= data[2];
            ch_data[0] <= 0;              
        end else begin
            ch_data[2] <= data[2];
            ch_data[0] <= data[0];
        end
    end 
end 

    
always@(posedge clk) begin
    if(reset) begin
        ch_valid <= 0;
        out_data_cnt <= 0;
        out_line_cnt <= 0;
    end else begin
        ch_valid <= valid[N-2];
        out_data_cnt <= valid[N-2] ? ((out_data_cnt == img_width - 1) ? 0 : out_data_cnt + 1) : out_data_cnt;
        out_line_cnt <= valid[N-2]&&(out_data_cnt == img_width - 1) ? ((out_line_cnt == img_height - 1) ? 0 : out_line_cnt + 1) : out_line_cnt;
    end
end

//单路输出
always@(posedge clk) begin
    if(reset) begin
        valid_o <= 0;
        prev_line_data_o <= 0;
        cur_line_data_o <= 0;
        next_line_data_o <= 0;
    end else begin
        valid_o <= ch_valid;
        prev_line_data_o <= ch_data[2];
        cur_line_data_o <= ch_data[1];
        next_line_data_o <= ch_data[0];
    end
end    

    
endmodule
