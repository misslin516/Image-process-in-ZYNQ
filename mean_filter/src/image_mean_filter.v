`timescale 1ns / 1ps

module image_mean_filter(
    input wire clk                  ,
    input wire reset                ,
       
    input wire [10:0] img_width     ,
    input wire [9:0] img_height     ,
       
    input wire valid_i              ,
    input wire [23:0] img_data_i    ,
    
    input wire      frame_clk       ,
    input wire      frame_ce        ,
    
    output wire     frame_clk_out   ,   
    output wire     frame_ce_out    ,   
    
    output reg valid_o              ,
    output reg [23:0] img_data_o
);//need delay 1292 clk

//常量声明
localparam MODE = 1;//0表示彩色图像输出，1表示灰度图像输出
localparam DELAY_CNT = 'd1292;

//变量声明
wire valid;
wire [23:0] prev_line_data;
wire [23:0] cur_line_data;
wire [23:0] next_line_data;
reg valid_d1;
reg [23:0] prev_line_data_d1;
reg [23:0] cur_line_data_d1;
reg [23:0] next_line_data_d1;

reg [23:0] prev_line_data_d2;
reg [23:0] cur_line_data_d2;
reg [23:0] next_line_data_d2;
reg [10:0] x_cnt;

reg valid_s;
reg [23:0] prev_line_data_d2_s;
reg [23:0] cur_line_data_d2_s;
reg [23:0] next_line_data_d2_s;
reg [23:0] prev_line_data_d1_s;
reg [23:0] cur_line_data_d1_s;
reg [23:0] next_line_data_d1_s;
reg [23:0] prev_line_data_s;
reg [23:0] cur_line_data_s;
reg [23:0] next_line_data_s;

wire [7:0] R0, G0, B0;
wire [7:0] R1, G1, B1;
wire [7:0] R2, G2, B2;
wire [7:0] R3, G3, B3;
wire [7:0] R4, G4, B4;
wire [7:0] R5, G5, B5;
wire [7:0] R6, G6, B6;
wire [7:0] R7, G7, B7;
wire [7:0] R8, G8, B8;

reg valid_s_d1;
reg [9:0] R_sum0, G_sum0, B_sum0;
reg [10:0] R_sum1, G_sum1, B_sum1;

reg valid_s_d2;
wire [11:0] R_sum2, G_sum2, B_sum2;
reg [18:0] R_sum3, G_sum3, B_sum3;
wire [18:0] RGB_sum;
wire [7:0] gray;

image_line_buffer u_image_line_buffer(
    .clk              ( clk              ),
    .reset            ( reset            ),
    .img_width        ( img_width        ),
    .img_height       ( img_height       ),
    .valid_i          ( valid_i          ),
    .img_data_i       ( img_data_i       ),
    .valid_o          ( valid            ),
    .prev_line_data_o ( prev_line_data   ),
    .cur_line_data_o  ( cur_line_data    ),
    .next_line_data_o  ( next_line_data  )
);//need 1287clk

always@(posedge clk) begin
    if(reset) begin
        valid_d1 <= 0;
        prev_line_data_d1 <= 0;
        cur_line_data_d1 <= 0;
        next_line_data_d1 <= 0;
        prev_line_data_d2 <= 0;
        cur_line_data_d2 <= 0;
        next_line_data_d2 <= 0;
    end else begin
        valid_d1 <= valid;
        prev_line_data_d1 <= prev_line_data;
        cur_line_data_d1 <= cur_line_data;
        next_line_data_d1 <= next_line_data;
        prev_line_data_d2 <= prev_line_data_d1;
        cur_line_data_d2 <= cur_line_data_d1;
        next_line_data_d2 <= next_line_data_d1;
    end
end  

//边界数据处理
always@(posedge clk) begin
    if(reset) begin
        x_cnt <= 0;
    end else begin
        x_cnt <= valid_d1 ? ((x_cnt == img_width - 1) ? 0 : x_cnt + 1) : x_cnt;
    end
end

always@(posedge clk) begin
    if(reset) begin
        valid_s <= 0;
        prev_line_data_d2_s <= 0;
        cur_line_data_d2_s <= 0;
        next_line_data_d2_s <= 0;
        prev_line_data_d1_s <= 0;
        cur_line_data_d1_s <= 0;
        next_line_data_d1_s <= 0;
        prev_line_data_s <= 0;
        cur_line_data_s <= 0;
        next_line_data_s <= 0;
    end else begin
        valid_s <= valid_d1;
        prev_line_data_d1_s <= prev_line_data_d1;
        cur_line_data_d1_s <= cur_line_data_d1;
        next_line_data_d1_s <= next_line_data_d1;
        if(x_cnt == 0) begin
           prev_line_data_d2_s <= prev_line_data_d1;
           cur_line_data_d2_s <= cur_line_data_d1;
           next_line_data_d2_s <= next_line_data_d1;
           prev_line_data_s <= prev_line_data;
           cur_line_data_s <= cur_line_data;
           next_line_data_s <= next_line_data;
        end if(x_cnt == img_width - 1) begin
           prev_line_data_d2_s <= prev_line_data_d2;
           cur_line_data_d2_s <= cur_line_data_d2;
           next_line_data_d2_s <= next_line_data_d2;
           prev_line_data_s <= prev_line_data_d1;
           cur_line_data_s <= cur_line_data_d1;
           next_line_data_s <= next_line_data_d1;
        end else begin
           prev_line_data_d2_s <= prev_line_data_d2;
           cur_line_data_d2_s <= cur_line_data_d2;
           next_line_data_d2_s <= next_line_data_d2;
           prev_line_data_s <= prev_line_data;
           cur_line_data_s <= cur_line_data;
           next_line_data_s <= next_line_data;
        end
    end
end
/************这里的模型可以写为************
/*--------------------------------------------------------------------------------------------*/
/*************  | prev_line_data_d2_s|  prev_line_data_d1_s|   prev_line_data_s|  ************/
/*************  | cur_line_data_d2_s |  cur_line_data_d1_s |   cur_line_data_s |  ************/
/*************  | next_line_data_d2_s|  next_line_data_d1_s|   next_line_data_s|  ************/
/*--------------------------------------------------------------------------------------------*/
assign {R0, G0, B0} = prev_line_data_d2_s;
assign {R1, G1, B1} = cur_line_data_d2_s ;
assign {R2, G2, B2} = next_line_data_d2_s;
assign {R3, G3, B3} = prev_line_data_d1_s;
assign {R4, G4, B4} = cur_line_data_d1_s ;
assign {R5, G5, B5} = next_line_data_d1_s;
assign {R6, G6, B6} = prev_line_data_s   ;
assign {R7, G7, B7} = cur_line_data_s    ;
assign {R8, G8, B8} = next_line_data_s   ;

always@(posedge clk) begin
    if(reset) begin
        valid_s_d1 <= 0;
        {R_sum0, G_sum0, B_sum0} <= 0;
        {R_sum1, G_sum1, B_sum1} <= 0;
    end else if(valid_s) begin
        valid_s_d1 <= 1;
        R_sum0 <= R0 + R1 + R2 + R3;
        G_sum0 <= G0 + G1 + G2 + G3;
        B_sum0 <= B0 + B1 + B2 + B3;
        R_sum1 <= R4 + R5 + R6 + R7 + R8;
        G_sum1 <= G4 + G5 + G6 + G7 + G8;
        B_sum1 <= B4 + B5 + B6 + B7 + B8;
    end else 
        valid_s_d1 <= 0;
end

assign R_sum2 = R_sum0 + R_sum1;
assign G_sum2 = G_sum0 + G_sum1;
assign B_sum2 = B_sum0 + B_sum1;

//彩色图像 1/9 = 0.1111，扩大10bit，即1024/9约等于114 = 128 - 16 + 2
//灰度图像 1/27 = 0.037，扩大10bit，即1024/27约等于40 = 32 + 8
always@(posedge clk) begin
    if(reset) begin
        valid_s_d2 <= 0;
        {R_sum3, G_sum3, B_sum3} <= 0;
    end else if(valid_s_d1) begin
        valid_s_d2 <= 1;
        if(MODE) begin //灰度
           R_sum3 <= {R_sum2, 5'b0} + {R_sum2, 3'b0};
           G_sum3 <= {G_sum2, 5'b0} + {G_sum2, 3'b0};
           B_sum3 <= {B_sum2, 5'b0} + {B_sum2, 3'b0};
        end else begin//彩色
           R_sum3 <= {R_sum2, 7'b0} - {R_sum2, 4'b0} + {R_sum2, 1'b0};
           G_sum3 <= {G_sum2, 7'b0} - {G_sum2, 4'b0} + {G_sum2, 1'b0};
           B_sum3 <= {B_sum2, 7'b0} - {B_sum2, 4'b0} + {B_sum2, 1'b0};
        end
    end else
        valid_s_d2 <= 0;
end

assign RGB_sum = R_sum3 + G_sum3 + B_sum3;
assign gray = RGB_sum[18] ? 255 : RGB_sum[17:10];

always@(posedge clk) begin
    if(reset) begin
        valid_o <= 0;
        img_data_o <= 0;
    end else if(valid_s_d2) begin
        valid_o <= 1;
        if(MODE) begin //灰度
            img_data_o <= {3{gray}};
        end else begin
            img_data_o[23:16] <= R_sum3[18] ? 255 : R_sum3[17:10];
            img_data_o[15:8] <= G_sum3[18] ? 255 : G_sum3[17:10];
            img_data_o[7:0] <= B_sum3[18] ? 255 : B_sum3[17:10];
        end
    end else begin
        valid_o <= 0;
    end
end

wire  [11:0] fifo_data_count_w1;
wire  [11:0] fifo_data_count_w2;
wire  rd_en1;
wire  rd_en2;

assign rd_en1 = (fifo_data_count_w1 == DELAY_CNT-1'b1)?1'b1:1'b0;
assign rd_en2 = (fifo_data_count_w2 == DELAY_CNT-1'b1)?1'b1:1'b0;


//delay fifo
fifo_delay u1_fifo_delay
(
  .clk          (clk            )         ,                // input wire clk
  .srst         (reset          )         ,              // input wire srst
  .din          (frame_clk      )         ,                // input wire [23 : 0] din
  .wr_en        (1'b1           )         ,            // input wire wr_en
  .rd_en        (rd_en1         )         ,            // input wire rd_en
  .dout         (frame_clk_out  )         ,              // output wire [23 : 0] dout
  .full         (               )         ,              // output wire full
  .empty        (               )         ,            // output wire empty
  .data_count   (fifo_data_count_w1)  // output wire [11 : 0] data_count
);    
    
fifo_delay u2_fifo_delay
(
  .clk          (clk            )         ,                // input wire clk
  .srst         (reset          )         ,              // input wire srst
  .din          (frame_ce       )         ,                // input wire [23 : 0] din
  .wr_en        (1'b1           )         ,            // input wire wr_en
  .rd_en        (rd_en2         )         ,            // input wire rd_en
  .dout         (frame_ce_out   )         ,              // output wire [23 : 0] dout
  .full         (               )         ,              // output wire full
  .empty        (               )         ,            // output wire empty
  .data_count   (fifo_data_count_w2)  // output wire [11 : 0] data_count
);    





endmodule
