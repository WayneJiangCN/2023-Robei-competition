`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/12 14:53:45
// Design Name: 
// Module Name: ccd_top_tb
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

module ccd_top_tb;

	reg Clk;
	reg Rst_n;
	wire adclk;
	wire si;
	wire uart_txd;
	reg [7:0] din;
	wire wrreq;
	wire ccd_clk;
	reg ad_otr;
	
	ccd_top ccd_top_tb(
		.sys_clk(Clk),
		.sys_rst_n(Rst_n),
		.ad_clk(adclk),
		.ad_data(din),
		.ad_otr(ad_otr),
		.ccdclk(ccd_clk),
		.si(si),
		.uart_txd(uart_txd)
	);
    //Ð´Êý¾Ý
    reg ccd_clk_reg;
    wire flag;
    assign flag = (~ccd_clk)&ccd_clk_reg;
        always @ ( posedge Clk ) begin
        if ( !Rst_n )
            ccd_clk_reg <= 8'd0;
        else
            ccd_clk_reg <= ccd_clk;
    end 
    always @ ( posedge Clk ) begin
        if ( !Rst_n )
            din <= 8'd1;
        else if ( flag )
            din <= din + 1'b1;
    end
	
	initial Clk = 1;
	always#(`clk_period/2)Clk = ~Clk;
	
	initial begin
		Rst_n = 1'b0;
		ad_otr = 1'd0;
		#(`clk_period*20 + 1 )
		Rst_n = 1'b1;
		#`clk_period;
		#(`clk_period*128*10000+100);
        #(`clk_period*20)
		$stop;	
	end

    
    
    

endmodule
