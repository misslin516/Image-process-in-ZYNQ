module binarization(
    //module clock
    input               clk              ,// 时钟信号
    input               rst_n            ,// 复位信号（低有效）

    //图像处理前的数据接口
    input               gray_vsync       ,// vsync信号
    input               gray_clken       ,// 时钟使能信号信号
    input               gray_data_valid  ,// 数据有效信号
    input   [7:0]       luminance        ,          

    //图像处理后的数据接口
    output              binary_vsync     ,// vsync信号
    output              binary_clken     ,// 时钟使能信号
    output              binary_data_valid,// 数据有效信号
    output  [23:0]      binary_data       //
);

parameter THRESHOLD = 8'd80;    //二值化的阈值

//reg define
reg    gray_vsync_d;
reg    gray_clken_d;
reg    gray_data_valid_d;
reg    monoc;                      //monochrome（1=白，0=黑）

//*****************************************************
//**                    main code
//*****************************************************

assign  binary_vsync = gray_vsync_d;
assign  binary_clken = gray_clken_d;
assign  binary_data_valid = gray_data_valid_d;
assign  binary_data = {24{monoc}};

//二值化
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        monoc <= 1'b0;
    else if(luminance > THRESHOLD)  //比较图像灰度值与阈值的大小
        monoc <= 1'b1;
    else
        monoc <= 1'b0;
end

//延时1拍以同步时钟信号
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        gray_vsync_d <= 1'd0;
        gray_clken_d <= 1'd0;
        gray_data_valid_d <= 1'd0;
    end
    else begin
        gray_vsync_d <= gray_vsync;
        gray_clken_d <= gray_clken;
        gray_data_valid_d <= gray_data_valid;
    end
end

endmodule 
