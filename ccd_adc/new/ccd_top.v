`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/11 20:26:36
// Design Name: 
// Module Name: ccd_top
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


module ccd_top(
   input                 sys_clk     ,  //ϵͳʱ��
   input                 sys_rst_n   ,  //ϵͳ��λ���͵�ƽ��Ч

   //ADоƬ�ӿ�
   input     [7:0]       ad_data     ,  //AD��������
   //ģ�������ѹ�������̱�־(��������δ�õ�)
   input                 ad_otr      ,  //0:�����̷�Χ 1:��������
   output                ad_clk      ,   //AD(AD9280)����ʱ��,���֧��32Mhzʱ�� 
   output               uart_txd     ,
   
   output               ccdclk       ,
   output               si            
    );

wire wrreq;
wire rdreq;
wire [7:0] tx_data;
wire [7:0] dealdata;
wire full;
wire empty;
wire TX_Done;
wire data_128_en;
wire Dealdone;
ccd_dirve   u_ccd_dirve
(
   .clk(sys_clk),
   .rst_n(sys_rst_n),
   .adclk(ad_clk),
   .si(si),
   .empty(empty),
   .wrreq(wrreq),
   .ccdclk(ccdclk)
    //fiforst,
);
data_deal_uart u_data_deal_uart
(
    .clk(sys_clk), 
    .rst_n(sys_rst_n),
    .TX_Done_Sig(TX_Done),
    .DealDone(Dealdone),
    .dealdata(dealdata),
    .data(tx_data),
    .full(full),
    .rdreq(rdreq),
    .data_128_en(data_128_en)
);
sync_fifo_cnt u_sync_fifo_cnt (
       .clk(sys_clk),      // input wire clk
       .rst_n(sys_rst_n),    // input wire srst
       .data_in(ad_data),      // input wire [7 : 0] din
       .wr_en(wrreq),  // input wire wr_en
       .rd_en(rdreq),  // input wire rd_en
       .data_out(tx_data),    // output wire [7 : 0] dout
       .full(full),    // output wire full
       .empty(empty)  // output wire empty
);
uart_send  u_uart_send(
                    .sys_clk(sys_clk),
                    .sys_rst_n(sys_rst_n),
                    .uart_en(rdreq),
                    .data_128_en(data_128_en),
                    .uart_din(dealdata),
                    .uart_txd(uart_txd),
                    .empty(empty),
                    .uart_tx_flag(TX_Done)                           
                    );
endmodule
