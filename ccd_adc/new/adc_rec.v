`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/11 20:28:12
// Design Name: 
// Module Name: adc_rec
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


//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           ad_wave_rec
// Last modified Date:  2019/07/31 17:04:35
// Last Version:        V1.0
// Descriptions:        
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/07/31 17:04:35
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ad_rec(
    input                 clk         ,  //时钟
    input                 rst_n       ,  //复位信号，低电平有效
    
    input         [7:0]   ad_data     ,  //AD输入数据
    //模拟输入电压超出量程标志(本次试验未用到)
    input                 ad_otr      ,  //0:在量程范围 1:超出量程
    output   reg          ad_clk         //AD(TLC5510)驱动时钟,最大支持20Mhz时钟
    );

//*****************************************************
//**                    main code 
//*****************************************************
localparam  CLK_DIVIDE = 4'd8     ;        // 时钟分频系数
//时钟分频(8分频,时钟频率为6.25Mhz),产生AD时钟
reg [2:0] clk_cnt;
always @(posedge clk or negedge rst_n) begin
    if(rst_n == 1'b0)begin
        ad_clk <= 1'b0;
        clk_cnt <= 3'b0;
      end  
    else if(clk_cnt  <=CLK_DIVIDE/2 - 1'd1)begin
        clk_cnt <= 3'b0;
        ad_clk <= ~ad_clk;
    end
    else begin
        clk_cnt <= clk_cnt + 1'b1;
        ad_clk <= ad_clk;
    end
         
end    

endmodule

