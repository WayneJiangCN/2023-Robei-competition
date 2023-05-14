module	ccd_dirve
(
	clk,
	rst_n,
	adclk,
	si,
	empty,
	wrreq,
	ccdclk,
	//fiforst,
	usedw
);
	input	clk;
	input rst_n;
	input	empty;
	input	[8:0]usedw;
	output	si;
	output	wrreq;
	output	adclk;
	output	ccdclk;
	//output	fiforst;
	parameter	CLK1M	=	8'd50;
	reg	[4:0]clk_count;
	reg	[4:0]si_count;
	reg	Adclk;
	reg	Ccdclk;
	reg	Si;
	reg	Wrreq;
	reg	start;
	/*************************************产生ad与ccd时序*/
	always @ ( posedge clk or negedge rst_n )
		if( !rst_n )begin	
			clk_count <= 5'b0;	
			Adclk	<=	1'd1;	
			Ccdclk <= 1'd0;	
		end
		else if( !start )begin	
			clk_count <= 5'b0;	
			Adclk	<=	1'd1;	
			Ccdclk <= 1'd0;	
		end
		else if( clk_count == CLK1M/2-1 )begin	
			clk_count <= 5'b0;	
			Adclk <= ~Adclk;	 //产生1Madc和ccd的时钟
			Ccdclk <= ~Ccdclk;	
		end
		else
			clk_count <= clk_count + 1'b1;
	/*******************************************/		
	parameter	EXPOSE_TIME	=	25'd5000000;	
	reg	[24:0]expose_count;
	parameter	SICLK	=	5'd12;
	reg	[7:0]count;
	reg	[2:0]i;
	always @ ( posedge clk or negedge rst_n )
		if( !rst_n )	
			expose_count <= 25'd0;
		else if( expose_count == EXPOSE_TIME )	
			expose_count <= 25'd0;
		else if( start ) 
			expose_count <= expose_count + 1'b1;
			
	always @ ( posedge clk or negedge rst_n )
		if( !rst_n )
		begin	Si <= 1'b0;	si_count <= 5'd0;	Wrreq <= 1'b0;	i <= 3'b0;	start <= 1'b0;	count <= 8'd0;	end
		else
			begin
				case(i)
					3'b000:
						begin	if( empty )	start <= 1'b1;	if(start)	i <= i+1'b1;	end
					3'b001:
						if( !Adclk )	
							begin	Si <= 1'b0;	i <= i+1'b1;	end
					3'b010:
						if( Adclk )
							begin	
								si_count <= si_count+1'b1;	
								if( si_count == SICLK )
									begin	Si <= 1'b1;	i <= i+1'b1;	si_count <= 5'd0;	end
							end
					3'b011:
						if( !Adclk )
							begin
								si_count <= si_count+1'b1;	
								if( si_count == SICLK )
									begin	Si <= 1'b0;	i <= i+1'b1;	si_count <= 5'd0;	end
							end		
					3'b100:
						if( Adclk )	
							begin
								count <= count+1'b1;	
								i <= i+1'b1;
								if( count > 8'd1 )	begin Wrreq <= 1'b1;end
							end
					3'b101:
						begin
							if( count > 8'd1 )	Wrreq <= 1'b0;
							if( count == 8'd130 )
								begin
									if( expose_count == 25'd0 )
										begin
											count <= 8'd0;
											start <= 1'd0;
											i <= 3'b0;
										end
								end
							else	if( !Adclk )	i <= 3'b100;
						end
				endcase
			end
	assign	adclk = Adclk;
	assign	ccdclk = Ccdclk;
	assign	si = Si;
	assign	wrreq = Wrreq;
	//assign	fiforst = !rst_n;
endmodule 