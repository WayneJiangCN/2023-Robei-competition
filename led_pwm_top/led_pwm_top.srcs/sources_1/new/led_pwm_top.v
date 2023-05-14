`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/24 19:30:52
// Design Name: 
// Module Name: led_pwm_top
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


module led_pwm_top(
sys_clk,
sys_rst_n,
sdo,
cs,
nc,
sck,
led_pwm);

//---Ports declearation: generated by Robei---
input sys_clk;
input sys_rst_n;
input sdo;
output cs;
output nc;
output sck;
output led_pwm;

wire sys_clk;
wire sys_rst_n;
wire sdo;
wire cs;
wire nc;
wire sck;
wire led_pwm;
wire [7:0] Light_Sensor_ALS2_w_Ambient_Val;

//----Code starts here: integrated by Robei-----




//---Module instantiation---
led_disp led_disp2(
    .clk(sys_clk),
    .rst_n(sys_rst_n),
    .data(Light_Sensor_ALS2_w_Ambient_Val),
    .led_pwm(led_pwm));

Light_Sensor_ALS #( 3, 10, 100) Light_Sensor_ALS2(
    .w_Rst_L(sys_rst_n),
    .i_Clk(sys_clk),
    .i_SPI_MISO(sdo),
    .w_Ambient_Val(Light_Sensor_ALS2_w_Ambient_Val),
    .o_SPI_Clk(sck),
    .o_SPI_MOSI(nc),
    .o_SPI_CS_n(cs));
ila_0 u_ila_0 (
        .clk(sys_clk), // input wire clk
    
    
        .probe0(Light_Sensor_ALS2_w_Ambient_Val) // input wire [7:0] probe0
    );
endmodule    //led_pwm_m