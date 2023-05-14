`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/11 20:57:38
// Design Name: 
// Module Name: step_AB_control
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


module step_AB_control(
        sys_clk,
        sys_rst_n, 
        step_dir_A,
        step_en_A,
        step_pul_A,
        step_dir_B,
        step_en_B,
        step_pul_B
    );
input sys_clk;
input sys_rst_n;
output step_dir_A;
output step_en_A;
output step_pul_A;
output step_dir_B;
output step_en_B;
output step_pul_B;
wire sys_clk;
wire sys_rst_n;
wire key;
wire step_dir_A;
wire step_en_A;
wire step_pul_A;
wire step_dir_B;
wire step_en_B;
wire step_pul_B;
wire stepper_dir_B;
wire stepper_dir_A;




                                                                                    


endmodule
