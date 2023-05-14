`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/16 18:47:22
// Design Name: 
// Module Name: step_tb
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

`define clock_period 20
module step_tb;

    reg sys_clk;
    reg sys_rst_n;

    reg key; 
    wire step_dir_A;
    wire step_pul_A;
    wire step_en_A;
    wire step_dir_B;
    wire step_pul_B;
    wire step_en_B;
     reg [15:0] myrand;     
step_top u_step_top(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n),
    .key(key),
    .step_dir_A(step_dir_A),
    .step_pul_A(step_pul_A),
    .step_en_A(step_en_A),
    .step_dir_B(step_dir_B),
    .step_pul_B(step_pul_B),
    .step_en_B(step_en_B)

    );
    
    initial sys_clk = 1'b1;
    always#(`clock_period/2) sys_clk = ~sys_clk;

    
    
    initial
    begin 
    sys_rst_n = 1'b0;
     key = 1'b1;
     myrand = 'd0;
    #(`clock_period*10)  sys_rst_n = 1'b1;
    #(`clock_period*10 +1);

        myrand  = 200;
        key = ~key;
        #(`clock_period*myrand) 
        key = 1;
         
         #(`clock_period*128*100000+100);
         #(`clock_period*128*100000+100);
              $stop;
    end
        

endmodule 
