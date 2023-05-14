`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/10 22:33:01
// Design Name: 
// Module Name: sensor_top
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


module sensor_top(

    input sys_clk       ,
    input sys_rst_n     ,
    
    //´®¿Ú
    output  uart_txd ,
    
    
    //US_100 ³¬Éù²¨´«¸ÐÆ÷
    input echo          ,
    
    output trig         
    //output reg led          
    );
wire uart_txd;
wire echo;
wire trig;
  
 wire us_100_en;
 wire [7:0] distance;

 
 wire distance_en;


US_100 u_us_100m(
       .sys_clk(sys_clk)                  ,
       .sys_rst(sys_rst_n)                ,
       .echo(echo)                        ,
       .trig(trig)                        ,
       .en(us_100_en)                     ,
       .en_led()                          ,
       .data_en(distance_en)              ,
       .data(distance)
        );
uart_send  u_uart_send(
            .sys_clk(sys_clk)             ,
            .sys_rst_n(sys_rst_n)         ,
            .uart_en(distance_en)         ,
            .uart_din(distance)           ,
            .uart_txd(uart_txd)           ,
            .tx_cnt()                     
            );
endmodule
