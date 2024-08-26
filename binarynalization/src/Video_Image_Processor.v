module Video_Image_Processor(
    input         clk,    //cmos 像素时钟
    input         rst_n,  
    
    //预处理图像
    input         pre_image_vsync, //预处理图像场同步信号
    input         pre_image_clken, //预处理图像时钟使能信号
    input         pre_data_valid,  //预处理图像数据有效信号
    input [23:0]  pre_image_data,  //预处理图像数据
        
    //处理后图像
    output        pos_image_vsync, //处理后图像场同步信号
    output        pos_image_clken, //处理后图像时钟使能信号
    output        pos_data_valid, //处理后图像数据有效信号
    output [23:0] pos_image_data  //处理后图像数据

);

//wire define 
wire [7:0]  gray_data ;
wire        ycbcb_vsync;
wire        ycbcbr_clken;
wire        ycbcr_valid;
wire [23:0] yuv;

//*****************************************************
//**                    main code
//*****************************************************
assign gray_data = yuv[7:0];



//rgb转ycbcr模块
rgbtoyuv rgbtoyuv_inst
(
    .sys_clk            (clk              ) ,
    .rst_n              (rst_n            ) ,
    
    .frame_clk          (pre_image_vsync  ) ,  
    .frame_clk_en       (pre_image_clken  ) ,
    .frame_data_en      (pre_data_valid   ) ,
    .frame_data         (pre_image_data   ) ,
   
    .frame_clk_out      (ycbcb_vsync      ) ,   
    .frame_clk_en_out   (ycbcbr_clken     ) ,
    .frame_data_en_out  (ycbcr_valid      ) ,
    .frame_data_out     (yuv              )

);


//二值化模块
binarization u_binarization(
	.clk               (clk),
	.rst_n             (rst_n),
	                   
	                   
	.gray_vsync        (ycbcb_vsync),
	.gray_clken        (ycbcbr_clken),
	.gray_data_valid   (ycbcr_valid),
	.luminance         (gray_data),
	                 
	                 
	.binary_vsync      (pos_image_vsync),
	.binary_clken      (pos_image_clken),
	.binary_data_valid (pos_data_valid),
	.binary_data       (pos_image_data)
);

endmodule 