`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/12 12:44:04
// Design Name: 
// Module Name: ccd_drive_tb
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/12 12:34:08
// Design Name: 
// Module Name: ccd_drive
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

module ccd_drive_tb;

	reg Clk;
	reg Rst_n;
	wire adclk;
	wire si;
	reg empty;
	
	wire wrreq;
	wire ccdclk;
	
	ccd_dirve u_ccd_dirve(
		.clk(Clk),
		.rst_n(Rst_n),
		.adclk(adclk),
		.si(si),
		.empty(empty),
		
		.wrreq(wrreq),
		.ccdclk(ccdclk)
	);
	
	initial Clk = 1;
	always#(`clk_period/2)Clk = ~Clk;
	
	initial begin
		Rst_n = 1'b0;
		empty = 1'd0;
		#(`clk_period*20 + 1 )
		Rst_n = 1'b1;
		#`clk_period;
		empty = 1'd1;
		#(`clk_period*128*100+100);
        empty = 1'd0;
        #(`clk_period*20)
		$stop;	
	end

endmodule

