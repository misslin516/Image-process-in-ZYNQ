module Video_Image_Processor(
    input         clk,    //cmos ����ʱ��
    input         rst_n,  
    
    //Ԥ����ͼ��
    input         pre_image_vsync, //Ԥ����ͼ��ͬ���ź�
    input         pre_image_clken, //Ԥ����ͼ��ʱ��ʹ���ź�
    input         pre_data_valid,  //Ԥ����ͼ��������Ч�ź�
    input [23:0]  pre_image_data,  //Ԥ����ͼ������
        
    //�����ͼ��
    output        pos_image_vsync, //�����ͼ��ͬ���ź�
    output        pos_image_clken, //�����ͼ��ʱ��ʹ���ź�
    output        pos_data_valid, //�����ͼ��������Ч�ź�
    output [23:0] pos_image_data  //�����ͼ������

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



//rgbתycbcrģ��
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


//��ֵ��ģ��
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