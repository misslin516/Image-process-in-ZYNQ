`timescale 1ns / 1ps

module image_median_filter
(
    input clk                   ,
    input reset                 ,
    //resolution   
    input [10:0] img_width      ,
    input [9:0] img_height      ,
       
     //clk and en --in 
    input   frame_clk           ,
    input   frame_ce            ,
    
    //valid and data --in
    input valid_i               ,
    input [23:0] img_data_i     ,
       
    //vlaid and data -- out
    output reg valid_o          , ///delay 1296clk
    output reg [23:0] img_data_o,
    //it need delay 1296clk through test
    output     frame_clk_out    ,
    output     frame_ce_out    
);
/*******************para*************************/
parameter  Dalay_cnt = 'd1296;


//常量声明
localparam N = 3;

//变量声明
/*******************wire and reg*************************/
wire valid_gray;
wire [7:0] img_data_gray;

wire valid;
wire [7:0] prev_line_data;
wire [7:0] cur_line_data;
wire [7:0] next_line_data;
reg valid_d1;
reg [7:0] prev_line_data_d1;
reg [7:0] cur_line_data_d1;
reg [7:0] next_line_data_d1;

reg [7:0] prev_line_data_d2;
reg [7:0] cur_line_data_d2;
reg [7:0] next_line_data_d2;
reg [10:0] x_cnt;

reg valid_s;
reg [7:0] prev_line_data_d2_s;
reg [7:0] cur_line_data_d2_s;
reg [7:0] next_line_data_d2_s;
reg [7:0] prev_line_data_d1_s;
reg [7:0] cur_line_data_d1_s;
reg [7:0] next_line_data_d1_s;
reg [7:0] prev_line_data_s;
reg [7:0] cur_line_data_s;
reg [7:0] next_line_data_s;

wire valid_sort0;
wire [7:0] prev_line_max_data;
wire [7:0] prev_line_mid_data;
wire [7:0] prev_line_min_data;

wire [7:0] cur_line_max_data;
wire [7:0] cur_line_mid_data;
wire [7:0] cur_line_min_data;

wire [7:0] next_line_max_data;
wire [7:0] next_line_mid_data;
wire [7:0] next_line_min_data;

wire valid_sort1;
wire [7:0] max_mid_data;
wire [7:0] mid_mid_data;
wire [7:0] min_mid_data;

wire valid_sort2;
wire [7:0] mid_data;

wire [10:0] fifo_data_count1;
wire [10:0] fifo_data_count2;
wire  rd_en_delay1;
wire  rd_en_delay2;

/*******************assign  *************************/
assign rd_en_delay1 = (fifo_data_count1 == Dalay_cnt)?1'b1:1'b0;
assign rd_en_delay2 = (fifo_data_count2 == Dalay_cnt)?1'b1:1'b0;

/*******************inst and always*************************/
image_rgb2gray u_image_rgb2gray(
    .clk        ( clk        ),
    .reset      ( reset      ),
    .valid_i    ( valid_i    ),
    .img_data_i ( img_data_i ),
    .valid_o    ( valid_gray    ),
    .img_data_o  ( img_data_gray  )
);//need 3 clk


image_line_buffer u_image_line_buffer(
    .clk              ( clk              ),
    .reset            ( reset            ),
    .img_width        ( img_width        ),
    .img_height       ( img_height       ),
    .valid_i          ( valid_gray          ),
    .img_data_i       ( img_data_gray       ),
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

//注意查看有效值的延迟参数
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
        end else if(x_cnt == img_width - 1) begin
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

//第1个周期
sort u_sort0(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_s ),
    .data0    ( prev_line_data_d2_s ),
    .data1    ( prev_line_data_d1_s  ),
    .data2    ( prev_line_data_s ),
    .valid_o  ( valid_sort0 ),
    .max_data ( prev_line_max_data ),
    .mid_data ( prev_line_mid_data ),
    .min_data ( prev_line_min_data )
);

sort u_sort1(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_s ),
    .data0    ( cur_line_data_d2_s ),
    .data1    ( cur_line_data_d1_s  ),
    .data2    ( cur_line_data_s ),
    .valid_o  (  ),
    .max_data ( cur_line_max_data ),
    .mid_data ( cur_line_mid_data ),
    .min_data ( cur_line_min_data )
);

sort u_sort2(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_s ),
    .data0    ( next_line_data_d2_s ),
    .data1    ( next_line_data_d1_s  ),
    .data2    ( next_line_data_s ),
    .valid_o  (  ),
    .max_data ( next_line_max_data ),
    .mid_data ( next_line_mid_data ),
    .min_data ( next_line_min_data )
);

//第2个周期
sort u_sort3(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_sort0 ),
    .data0    ( prev_line_max_data ),
    .data1    ( cur_line_max_data  ),
    .data2    ( next_line_max_data ),
    .valid_o  ( valid_sort1 ),
    .max_data (  ),
    .mid_data ( max_mid_data ),
    .min_data (  )
);

sort u_sort4(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_sort0 ),
    .data0    ( prev_line_mid_data ),
    .data1    ( cur_line_mid_data  ),
    .data2    ( next_line_mid_data ),
    .valid_o  (  ),
    .max_data (  ),
    .mid_data ( mid_mid_data ),
    .min_data (  )
);

sort u_sort5(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_sort0 ),
    .data0    ( prev_line_min_data ),
    .data1    ( cur_line_min_data  ),
    .data2    ( next_line_min_data ),
    .valid_o  (  ),
    .max_data (  ),
    .mid_data ( min_mid_data ),
    .min_data (  )
);

//第3个周期
sort u_sort6(
    .clk      ( clk      ),
    .reset    ( reset    ),
    .valid_i  ( valid_sort1 ),
    .data0    ( max_mid_data ),
    .data1    ( mid_mid_data  ),
    .data2    ( min_mid_data ),
    .valid_o  ( valid_sort2 ),
    .max_data (  ),
    .mid_data ( mid_data ),
    .min_data (  )
);

always@(posedge clk) begin
    if(reset) begin
        valid_o <= 0;
        img_data_o <= 0;
    end else begin
        valid_o <= valid_sort2;
        //灰度图像
        img_data_o <= {3{mid_data}};
    end
end




//delay counter use FIFO to delay
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
  .din          (frame_ce         ),                // input wire [0: 0] din
  .wr_en        (1'b1             ),            // input wire wr_en
  .rd_en        (rd_en_delay2     ),            // input wire rd_en
  .dout         (frame_ce_out     ),              // output wire [0: 0] dout
  .full         (                 ),              // output wire full
  .empty        (                 ),            // output wire empty
  .data_count   (fifo_data_count2 )  // output wire [10 : 0] data_count
);    




endmodule
