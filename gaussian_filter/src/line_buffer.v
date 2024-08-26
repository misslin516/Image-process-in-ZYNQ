`timescale 1ns / 1ps


module line_buffer(
input wire clk,
input wire reset,
   
input wire [10:0] img_width,
   
input wire valid_i,
input wire [23:0] data_i,
   
output wire valid_o,
output wire [23:0] data_o
);

//变量声明
reg [10:0] wr_data_cnt;
wire rd_en;
wire [11:0] fifo_data_count_w;
    
//写入数据计数
always@(posedge clk or posedge reset) begin
    if(reset) begin
        wr_data_cnt <= 0;
    end else begin
        wr_data_cnt <= valid_i&&(wr_data_cnt < img_width) ? (wr_data_cnt + 1'b1) : wr_data_cnt;
    end
end

//assign rd_en = valid_i&&(wr_data_cnt == img_width) ? 1'b1 : 1'b0;
//等价于
assign rd_en = valid_i&&(fifo_data_count_w == img_width) ? 1'b1 : 1'b0;
assign valid_o = rd_en;

fifo_line_buffer u_fifo_line_buffer (
  .clk(clk),                // input wire clk
  .srst(reset),              // input wire srst
  .din(data_i),                // input wire [23 : 0] din
  .wr_en(valid_i),            // input wire wr_en
  .rd_en(rd_en),            // input wire rd_en
  .dout(data_o),              // output wire [23 : 0] dout
  .full(),              // output wire full
  .empty(),            // output wire empty
  .data_count(fifo_data_count_w)  // output wire [11 : 0] data_count
);    
    
endmodule
