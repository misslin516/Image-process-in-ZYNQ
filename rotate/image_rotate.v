`timescale 1ns / 1ps

module image_rotate(
   input wire clk,
   input wire reset,
   
   input wire [11:0] img_width,
   input wire [10:0] img_height,   
   input wire [8:0] angle,//0~360，表示旋转角度
   input wire [11:0] img_new_width,
   input wire [11:0] img_new_height,
   
   input wire valid_i,
   input wire [23:0] data_i,
   output wire wr_ready,
   
   output reg valid_o,
   output reg [23:0] data_o
    );

    //常量声明
    parameter Depth = 1280*720;

    //变量声明
    reg buffer0_status, buffer1_status;
    reg wr_flag;
    reg [11:0] wr_x_cnt;
    reg [10:0] wr_y_cnt;
    reg [9:0] addra;

    wire wr_finish;
    wire buffer0_wr, buffer1_wr;


    wire rd_en;
    reg [11:0] x;
    reg [11:0] y;
    wire [8:0] cos_val, sin_val;

    reg rd_en_d1;
    reg rd_finish;
    reg [12:0] x_c;
    reg [12:0] y_c;

    reg rd_en_d2;
    reg rd_finish_d1;
    reg rd_en_d3;
    reg rd_finish_d2;
    
    wire [21:0] x_m_sin, y_m_sin;
    wire [21:0] x_m_cos, y_m_cos;    

    reg rd_en_d4;
    reg rd_finish_d3;
    reg [22:0] x_r;
    reg [22:0] y_r;

    reg rd_en_d5;
    reg rd_finish_d4;
    wire [22:0] x_w;
    wire [22:0] y_w;
    reg [11:0] x_s;
    reg [10:0] y_s;
    reg out_flag;

    reg rd_en_d6;
    reg rd_finish_d5;
    reg out_flag_d1;
    reg rd_flag;
    reg [20:0] addrb;
    wire [23:0] buffer0_dout, buffer1_dout;

    reg rd_en_d7;
    reg out_flag_d2;
    reg rd_flag_d;

    //////////////////写数据
    //写入地址，wr_flag等于0时，写入buffer0，等于1时，写入buffer1
    always@(posedge clk ) begin
        if(reset) begin
            wr_flag <= 0;
            addra <= 0;
            wr_x_cnt <= 0;
            wr_y_cnt <= 0;
        end else begin
            wr_flag <= wr_finish ? ~wr_flag : wr_flag;
            addra <= wr_finish ? 0 : valid_i ? (addra + 1'b1) : addra;
            wr_x_cnt <= valid_i ? ((wr_x_cnt == img_width -1 ) ? 0 : wr_x_cnt + 1'b1) : wr_x_cnt;
            wr_y_cnt <= valid_i&&(wr_x_cnt == img_width -1 ) ? ((wr_y_cnt == img_height -1 ) ? 0 : wr_y_cnt + 1'b1) : wr_y_cnt;
        end
    end
    
    assign wr_finish = valid_i&&(wr_x_cnt == img_width -1 )&&(wr_y_cnt == img_height -1 ) ? 1'b1 : 1'b0;
    assign buffer0_wr = valid_i&(~wr_flag);
    assign buffer1_wr = valid_i&wr_flag;

    //缓存状态保存
    always@(posedge clk ) begin
        if(reset) begin
            buffer0_status <= 0;
            buffer1_status <= 0;
        end else begin
            buffer0_status <= (~wr_flag)&&wr_finish ? 1'b1 : (~rd_flag)&&rd_finish ? 1'b0 : buffer0_status;
            buffer1_status <= wr_flag&&wr_finish ? 1'b1 : rd_flag&&rd_finish ? 1'b0 : buffer1_status;
        end
    end    

    assign wr_ready = (~buffer0_status)|(~buffer1_status);

    //////////////////读数据

    //读取数据。缓存完一行，启动读数据。
    assign rd_en = buffer0_status|buffer1_status;
    
    //读地址，垂直镜像，从下往上
    always@(posedge clk ) begin
        if(reset) begin
            x <= 0;
            y <= 0;
        end else begin
            x <= rd_en ? ((x == img_new_width) ? 0 : x + 1'b1) : x;
            y <= rd_en&&(x == img_new_width) ? ((y == img_new_height -1 ) ? 0 : y + 1'b1) : y;
        end
    end 
    
    //cos函数计算， sin函数计算，左移8bit，有符号数
sin_table u_sin_table(
    .clk   ( clk   ),
    .rd_en ( rd_en ),
    .addr  ( angle  ),
    .dout  ( sin_val  )
);

cos_table u_cos_table(
    .clk   ( clk   ),
    .rd_en ( rd_en ),
    .addr  ( angle  ),
    .dout  ( cos_val )
);

    //切换到图像中心为原点的坐标系
    always@(posedge clk ) begin
        if(reset) begin
            rd_en_d1 <= 0;
            rd_finish <= 0;
            x_c <= 0;
            y_c <= 0;
        end else begin
            rd_en_d1 <= rd_en&&(x < img_new_width) ? 1'b1 : 1'b0;
            rd_finish <= rd_en&&(x == img_new_width)&&(y == img_new_height -1 ) ? 1'b1 : 1'b0;
            x_c <= x - img_new_width[11:1];
            y_c <= img_new_height[11:1] - y;       
        end
    end

    //符号数乘法， 延时2T
    always@(posedge clk ) begin
        if(reset) begin
            rd_en_d2 <= 0;
            rd_finish_d1 <= 0;
            rd_en_d3 <= 0;
            rd_finish_d2 <= 0;
        end else begin
            rd_en_d2 <= rd_en_d1;
            rd_finish_d1 <= rd_finish;       
            rd_en_d3 <= rd_en_d2;
            rd_finish_d2 <= rd_finish_d1;      
        end
    end

mult_gen_13x9 u_mult_gen_13x9_0 (
  .CLK(clk),  // input wire CLK
  .A(x_c),      // input wire [11 : 0] A
  .B(sin_val),      // input wire [8 : 0] B
  .P(x_m_sin)      // output wire [20 : 0] P
);    

mult_gen_13x9 u_mult_gen_13x9_1 (
  .CLK(clk),  // input wire CLK
  .A(y_c),      // input wire [11 : 0] A
  .B(sin_val),      // input wire [8 : 0] B
  .P(y_m_sin)      // output wire [20 : 0] P
);    

mult_gen_13x9 u_mult_gen_13x9_2 (
  .CLK(clk),  // input wire CLK
  .A(x_c),      // input wire [11 : 0] A
  .B(cos_val),      // input wire [8 : 0] B
  .P(x_m_cos)      // output wire [20 : 0] P
);    

mult_gen_13x9 u_mult_gen_13x9_3 (
  .CLK(clk),  // input wire CLK
  .A(y_c),      // input wire [11 : 0] A
  .B(cos_val),      // input wire [8 : 0] B
  .P(y_m_cos)      // output wire [20 : 0] P
);    
    

    //旋转计算公式
    always@(posedge clk ) begin
        if(reset) begin
            x_r <= 0;
            y_r <= 0;
            rd_en_d4 <= 0;
            rd_finish_d3 <= 0;
        end else begin
            x_r <= {x_m_cos[21], x_m_cos} - {y_m_sin[21], y_m_sin};
            y_r <= {x_m_sin[21], x_m_sin} + {y_m_cos[21], y_m_cos};
            rd_en_d4 <= rd_en_d3;
            rd_finish_d3 <= rd_finish_d2;  
        end
    end    

    //切换到以图像左上角顶点为原点的坐标系
    //判断是否映射到原图像外面
    assign x_w = x_r + {img_width[11:1], 8'b0};
    assign y_w = {img_height[10:1], 8'b0} - y_r;
    always@(posedge clk ) begin
        if(reset) begin
            x_s <= 0;
            y_s <= 0;
            out_flag <= 0;
            rd_en_d5 <= 0;
            rd_finish_d4 <= 0;
        end else begin
            x_s <= x_w[22] ?'b0 : x_w[21:8] >= img_width ? img_width - 1 : x_w[19:8];
            y_s <= y_w[22] ?'b0 : y_w[21:8] >= img_height ? img_height - 1 : y_w[18:8];
            out_flag <= x_w[22]||x_w[21:8] >= img_width||y_w[22]||y_w[21:8]>= img_height ? 1'b1 : 1'b0 ;
            rd_en_d5 <= rd_en_d4;
            rd_finish_d4 <= rd_finish_d3;
        end
    end    

    //计算地址，时序未优化
    always@(posedge clk ) begin
        if(reset) begin
            rd_flag <= 0;
            addrb <= 0;
            out_flag_d1 <= 0;
            rd_en_d6 <= 0;
            rd_finish_d5 <= 0;
        end else begin
            rd_flag <= rd_finish_d3 ? ~rd_flag : rd_flag;
            addrb <= y_s*img_width + x_s;
            out_flag_d1 <= out_flag;
            rd_en_d6 <= rd_en_d5;
            rd_finish_d5 <= rd_finish_d4;
        end
    end     

    //打一拍延时
    always@(posedge clk ) begin
        if(reset) begin
            rd_flag_d <= 0;
            rd_en_d7 <= 0;
            out_flag_d2 <= 0;
        end else begin
            rd_flag_d <= rd_flag;
            rd_en_d7 <= rd_en_d6;
            out_flag_d2 <= out_flag_d1;
        end
    end 

    //输出
    always@(posedge clk ) begin
        if(reset) begin
            valid_o <= 0;
            data_o <= 0;
        end else begin
            valid_o <= rd_en_d7;
            data_o <= out_flag_d2 ? 0 : rd_flag_d ? buffer1_dout : buffer0_dout;
        end
    end    

    
    // //buffer0
    // always@(posedge clk ) begin
        // if(buffer0_wr) begin
            // buffer0[addra] <= data_i;
        // end else begin
            // buffer0_dout <= buffer0[addrb];
        // end
    // end

    // //buffer1
    // always@(posedge clk ) begin
        // if(buffer1_wr) begin
            // buffer1[addra] <= data_i;
        // end else begin
            // buffer1_dout <= buffer1[addrb];
        // end
    // end
    
blk_mem_line_buffer u_blk_mem_line_buffer0 (
  .clka(clk),    // input wire clka
  .wea(buffer0_wr),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [10 : 0] addra
  .dina(data_i),    // input wire [23 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(addrb),  // input wire [10 : 0] addrb
  .doutb(buffer0_dout)  // output wire [23 : 0] doutb
);    
    
blk_mem_line_buffer u_blk_mem_line_buffer1 (
  .clka(clk),    // input wire clka
  .wea(buffer1_wr),      // input wire [0 : 0] wea
  .addra(addra),  // input wire [10 : 0] addra
  .dina(data_i),    // input wire [23 : 0] dina
  .clkb(clk),    // input wire clkb
  .addrb(addrb),  // input wire [10 : 0] addrb
  .doutb(buffer1_dout)  // output wire [23 : 0] doutb
);  
    
    
endmodule
