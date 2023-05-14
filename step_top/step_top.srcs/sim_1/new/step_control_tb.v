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

module step_control_tb;

	reg Clk;
	reg Rst_n;
	reg key_en;
	wire step_pul;
	wire step_dir;
	wire step_en;
	
	step_control u_step_control(
		.sys_clk(Clk),
		.sys_rst_n(Rst_n),
		.key_en(key_en),
		.stepper_step_out(step_pul),
		.step_dir(step_dir),
		.step_en(step_en)
	);

	
	initial Clk = 1;
	always#(`clk_period/2)Clk = ~Clk;
	
	initial begin
		Rst_n = 1'b0;
		#(`clk_period*20 + 1 )
		Rst_n = 1'b1;
		key_en = 1'd1;
		#`clk_period;
		#(`clk_period*128*10000+100);
        #(`clk_period*20)
		$stop;	
	end

    
    
    

endmodule
