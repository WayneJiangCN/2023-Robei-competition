//��������ʵ��ͬ��FIFO
module	sync_fifo_cnt
#(
	parameter   DATA_WIDTH = 'd8  ,							//FIFOλ��
    parameter   DATA_DEPTH = 'd128							//FIFO���   8*128
)
(
	input									clk		,		//ϵͳʱ��
	input									rst_n	,       //�͵�ƽ��Ч�ĸ�λ�ź�
	input	[DATA_WIDTH-1:0]				data_in	,       //д�������
	input									rd_en	,       //��ʹ���źţ��ߵ�ƽ��Ч
	input									wr_en	,       //дʹ���źţ��ߵ�ƽ��Ч
															
	output	reg	[DATA_WIDTH-1:0]			data_out,	    //���������
	output									empty	,	    //�ձ�־���ߵ�ƽ��ʾ��ǰFIFO�ѱ�д��
	output									full	,       //����־���ߵ�ƽ��ʾ��ǰFIFO�ѱ�����
	output	reg	[9 : 0]	fifo_cnt		//$clog2����2Ϊ��ȡ����	
);
 
//reg define
(* ram_style = "block" *) reg [DATA_WIDTH - 1 : 0] fifo_buffer[DATA_DEPTH - 1 : 0];	//�ö�ά����ʵ��RAM	
reg [9 : 0]	wr_addr;// = {default:0};				//д��ַ
reg [9 : 0]	rd_addr;// = {default:0};				//����ַ
 
//�����������¶���ַ
always @ (posedge clk) begin
	if (!empty && rd_en)begin							//��ʹ����Ч�ҷǿ�
		if(rd_addr == 'd127)
		    rd_addr <= 'd0;
        else
            rd_addr <= rd_addr + 1'd1;
		data_out <= fifo_buffer[rd_addr];
	end
end
//д����,����д��ַ
always @ (posedge clk) begin
	if (!full && wr_en)begin							//дʹ����Ч�ҷ���
		if(wr_addr == 'd127)
		    wr_addr <= 'd0;
        else
            wr_addr <= wr_addr + 1'd1;
		fifo_buffer[wr_addr]<=data_in;
	end
end
//���¼�����
always @ (posedge clk or negedge rst_n) begin
	if (!rst_n)
		fifo_cnt <= 0;
	else begin
		case({wr_en,rd_en})									//ƴ�Ӷ�дʹ���źŽ����ж�
			2'b00:fifo_cnt <= fifo_cnt;						//������д
			2'b01:	                               			//������
				if(fifo_cnt != 0)				   			//fifoû�б�����
					fifo_cnt <= fifo_cnt - 1'b1;   			//fifo����-1
			2'b10:                                 			//����д
				if(fifo_cnt != DATA_DEPTH)         			//fifoû�б�д��
					fifo_cnt <= fifo_cnt + 1'b1;   			//fifo����+1
			2'b11:fifo_cnt <= fifo_cnt;	           			//��дͬʱ
			default:;                              	
		endcase
	end
end
//���ݼ�����״̬����ָʾ�ź�
//���ݲ�ͬ��ֵ��������ư�ա����� �������ա�������
assign full  = (fifo_cnt == DATA_DEPTH) ? 1'b1 : 1'b0;		//���ź�
assign empty = (fifo_cnt == 0)? 1'b1 : 1'b0;				//���ź�
 
endmodule