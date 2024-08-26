`timescale 1ns / 1ps


module sort(
input clk,
input reset,
   
input valid_i,
input [7:0] data0,
input [7:0] data1,
input [7:0] data2,
input [3:0] data0_id,
input [3:0] data1_id,
input [3:0] data2_id,
   
output reg valid_o,
output reg [7:0] max_data,
output reg [7:0] mid_data,
output reg [7:0] min_data,
output reg [3:0] max_id,
output reg [3:0] mid_id,
output reg [3:0] min_id
);

always@(posedge clk ) begin
    if(reset) begin
        valid_o <= 0;
        max_data <= 0;
        mid_data <= 0;
        min_data <= 0;
        max_id <= 0;
        mid_id <= 0;
        min_id <= 0;
    end else begin
        valid_o <= valid_i;
        if(data0 >= data1 && data0 >= data2) begin
			max_data <= data0;
            max_id <= data0_id;
        end else if(data1 >= data0 && data1 >= data2) begin
			max_data <= data1;
            max_id <= data1_id;
        end else begin
			max_data <= data2;
            max_id <= data2_id;            
        end

        if((data1 >= data0 && data0 >= data2) || (data2 >= data0 && data0 >= data1)) begin
			mid_data <= data0;
            mid_id <= data0_id;
        end else if((data0 >= data1 && data1 >= data2) || (data2 >= data1 && data1 >= data0)) begin
			mid_data <= data1;
            mid_id <= data1_id;
        end else /*if((data0 >= data2 && data2 >= data1) || (data1 >= data2 && data2 >= data0))*/ begin
			mid_data <= data2;
            mid_id <= data2_id;
        end

        if(data2 >= data0 && data1 >= data0) begin
			min_data <= data0;
            min_id <= data0_id;
        end else if(data2 >= data1 && data0 >= data1) begin
			min_data <= data1;
            min_id <= data1_id;
        end else /*if(data0 >= data2 && data1 >= data2)*/ begin
			min_data <= data2;
            min_id <= data2_id;
        end
    end
end

    
endmodule
