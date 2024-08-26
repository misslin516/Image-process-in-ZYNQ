`timescale 1ns / 1ps


module image_line_buffer(
input clk,
input reset,

input [10:0] img_width,

input valid_i,
input [23:0] data_i,
output wr_ready,

input rd_en,
input [10:0] rd_addr,
input rd_finish,
output rd_ready,

output reg valid_o,
output reg [47:0] cur_line_data_o,
output reg [47:0] next_line_data_o
);



//变量声明
reg valid_d;
reg [23:0] data_d;
reg buffer0_status, buffer1_status, buffer2_status;
reg [1:0] wr_flag;
reg [10:0] wr_x_cnt;
reg [10:0] addra;
wire wr_finish;
wire buffer0_wr, buffer1_wr, buffer2_wr;
reg [1:0] rd_flag;
wire [10:0] addrb;
wire [47:0] buffer0_dout, buffer1_dout, buffer2_dout;
reg rd_en_d1;
reg [1:0] rd_flag_d;

////////////////////写数据
always@(posedge clk) begin
    if(reset) begin
        valid_d <= 0;
        data_d <= 0;
    end else begin
        valid_d <= valid_i;
        data_d <= data_i;
    end
end

//写入地址，wr_flag等于0时，写入buffer0，等于1时，写入buffer1
always@(posedge clk) begin
    if(reset) begin
        wr_flag <= 0;
        addra <= 0;
        wr_x_cnt <= 0;
    end else begin
        wr_flag <= wr_finish ? ((wr_flag == 2) ? 0 : wr_flag + 1) : wr_flag;
        addra <= wr_finish ? 0 : valid_d ? (addra + 1'b1) : addra;
        wr_x_cnt <= valid_d ? ((wr_x_cnt == img_width -1 ) ? 0 : wr_x_cnt + 1'b1) : wr_x_cnt;
    end
end
    
assign wr_finish = valid_d&&(wr_x_cnt == img_width -1 ) ? 1'b1 : 1'b0;
assign buffer0_wr = valid_d&&(wr_flag == 0) ? 1 : 0;
assign buffer1_wr = valid_d&&(wr_flag == 1) ? 1 : 0;
assign buffer2_wr = valid_d&&(wr_flag == 2) ? 1 : 0;

//缓存状态保存
always@(posedge clk) begin
    if(reset) begin
        buffer0_status <= 0;
        buffer1_status <= 0;
        buffer2_status <= 0;
    end else if(wr_finish) begin
        case(wr_flag)
        0: buffer0_status <= 1;
        1: buffer1_status <= 1;
        2: buffer2_status <= 1;
        endcase        
    end else if(rd_finish) begin
        case(rd_flag)
        0: buffer0_status <= 0;
        1: buffer1_status <= 0;
        2: buffer2_status <= 0;
        endcase        
    end
end    

assign wr_ready = (~buffer0_status)|(~buffer1_status)|(~buffer2_status);

///////////////////读数据

//缓存完一行，通知上一层可读取数据。
assign rd_ready = (buffer0_status&buffer1_status)|
                  (buffer1_status&buffer2_status)|
                  (buffer2_status&buffer0_status);
    
//读地址
assign addrb = rd_addr;

always@(posedge clk) begin
    if(reset) begin
        rd_flag <= 0;
    end else begin
        rd_flag <= rd_finish ? ((rd_flag == 2) ? 0 : rd_flag + 1) : rd_flag;
    end
end     

//打一拍延时
always@(posedge clk) begin
    if(reset) begin
        rd_flag_d <= 0;
        rd_en_d1 <= 0;
    end else begin
        rd_flag_d <= rd_flag;
        rd_en_d1 <= rd_en;
    end
end 

//输出
always@(posedge clk) begin
    if(reset) begin
        valid_o <= 0;
        cur_line_data_o <= 0;
        next_line_data_o <= 0;
    end else begin
        valid_o <= rd_en_d1;
        case(rd_flag_d)
        0: {cur_line_data_o, next_line_data_o} <= {buffer0_dout, buffer1_dout};
        1: {cur_line_data_o, next_line_data_o} <= {buffer1_dout, buffer2_dout};
        2: {cur_line_data_o, next_line_data_o} <= {buffer2_dout, buffer0_dout};
        endcase
    end
end    

    
//buffer0
blk_mem_line_buffer u_blk_mem_line_buffer0 (
  .clka(clk),    // input wire clka
  .wea(buffer0_wr),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [10 : 0] addra
  .dina({data_d, data_i}),    // input wire [47 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(addrb),  // input wire [10 : 0] addrb
  .doutb(buffer0_dout)  // output wire [47 : 0] doutb
);    

//buffer1
blk_mem_line_buffer u_blk_mem_line_buffer1 (
  .clka(clk),    // input wire clka
  .wea(buffer1_wr),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [10 : 0] addra
  .dina({data_d, data_i}),    // input wire [47 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(addrb),  // input wire [10 : 0] addrb
  .doutb(buffer1_dout)  // output wire [47 : 0] doutb
);     

//buffer2
blk_mem_line_buffer u_blk_mem_line_buffer2 (
  .clka(clk),    // input wire clka
  .wea(buffer2_wr),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [10 : 0] addra
  .dina({data_d, data_i}),    // input wire [47 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(addrb),  // input wire [10 : 0] addrb
  .doutb(buffer2_dout)  // output wire [47 : 0] doutb
);   
    
endmodule
