`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/12 21:20:49
// Design Name: 
// Module Name: sync_fifo_cnt_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ns
`define clk_period 20

module sync_fifo_cnt_tb;

	reg Clk;
	reg Rst_n;
	wire [7:0] data_out;
	reg [7:0] din;
	wire [9:0] fifo_cnt;
	wire wrreq;
	wire empty;
	wire full;
	reg rd_en;
	reg wr_en;
	
	sync_fifo_cnt u_sync_fifo_cnt_tb(
		.clk(Clk),
		.rst_n(Rst_n),
		.data_in(din),
		.rd_en(rd_en),
		.wr_en(wr_en),
		.data_out(data_out),
		.empty(empty),
		.full(full),
		.fifo_cnt(fifo_cnt)
	);
    //Ð´Êý¾Ý

    always @ ( posedge Clk ) begin
        if ( !Rst_n )
            din <= 8'd1;
           else
            din <= din + 1'b1;
    end
	
	initial Clk = 1;
	always#(`clk_period/2)Clk = ~Clk;
	
	initial begin
		Rst_n = 1'b0;
		wr_en = 1'd0;
		#(`clk_period*20 + 1 )
		Rst_n = 1'b1;
		rd_en = 1'd0;
		wr_en = 1'd1;
		#`clk_period;
		#(`clk_period*128*10+100);
		wr_en = 1'd0;
        #(`clk_period*20)
        rd_en = 1'd1;
        #(`clk_period*128*10+100);
        rd_en = 1'd1;
        #(`clk_period*20)
		$stop;	
	end

    
    
    

endmodule
