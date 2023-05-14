`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/13 15:59:12
// Design Name: 
// Module Name: data_deal_uart
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


module	data_deal_uart
(
	clk, 
	rst_n,
	TX_Done_Sig,
	dealdata,
	data,
	full,
	data_128_en,
	rdreq
);
	input	clk;
	input rst_n;
	input	TX_Done_Sig;
	input	full;
	input	[7:0]data;
	
	output	rdreq;
	output	[7:0]dealdata;
	output data_128_en;
	reg	Rdreq;
	reg	start;
	reg	[3:0]i;
	reg	[7:0]count;
	reg	[7:0]temp;
	reg data_128_en;	
	always @ (posedge clk or negedge rst_n)
		if( !rst_n )
			begin	i <= 3'd0;	count <= 7'd0;	Rdreq <=1'b0;	temp <= 8'd0;	start <= 1'b0;data_128_en=1'b0;end	
		else
				case(i)
					4'd0:	
						begin	
							if( full )	
								begin start	<= 1'b1;end
							if(start)	i <= 4'd5;	
						end
					4'd1:	
						begin	Rdreq <= 1'b1;	i <= i+1'b1;	end
					4'd2:	
						begin	Rdreq <= 1'b0;	i <= i+1'b1;	end	
					4'd3:	
						begin
							temp	<=	data;
							if(TX_Done_Sig)	begin	i <= i+1'b1;end	

						end
					4'd4:	
						begin
						    i <= 3'b0;
							count	<=	count+1'b1;
						end
                    4'd5:
                        begin
                    if(count==8'd128)	begin i = 4'd6;start <=	1'b0; end
                    if(count<8'd128)	i = 4'd1;
                    end
                    4'd6:	
                        begin    data_128_en <= 1'b1;    i <= i+1'b1;    end
                    4'd7:    
                        begin    data_128_en <= 1'b0;    i <= i+1'b1;    end    
                    4'd8:
                        begin 
                            temp	<=	8'b11111111;
                           if(TX_Done_Sig)begin i <= 4'b0;count = 8'd0; end
                     end
				endcase
	
	assign	rdreq = Rdreq;
	assign	dealdata	=	temp[7:0];//+8'd48;
	
endmodule  

