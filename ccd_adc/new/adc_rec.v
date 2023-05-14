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
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           ad_wave_rec
// Last modified Date:  2019/07/31 17:04:35
// Last Version:        V1.0
// Descriptions:        
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/07/31 17:04:35
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ad_rec(
    input                 clk         ,  //ʱ��
    input                 rst_n       ,  //��λ�źţ��͵�ƽ��Ч
    
    input         [7:0]   ad_data     ,  //AD��������
    //ģ�������ѹ�������̱�־(��������δ�õ�)
    input                 ad_otr      ,  //0:�����̷�Χ 1:��������
    output   reg          ad_clk         //AD(TLC5510)����ʱ��,���֧��20Mhzʱ��
    );

//*****************************************************
//**                    main code 
//*****************************************************
localparam  CLK_DIVIDE = 4'd8     ;        // ʱ�ӷ�Ƶϵ��
//ʱ�ӷ�Ƶ(8��Ƶ,ʱ��Ƶ��Ϊ6.25Mhz),����ADʱ��
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

