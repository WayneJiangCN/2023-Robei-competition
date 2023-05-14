module uart_send(
    input	      sys_clk,                  //ϵͳʱ��
    input         sys_rst_n,                //ϵͳ��λ���͵�ƽ��Ч

    
    output  reg   uart_txd               //UART���Ͷ˿�

    );
    
//parameter define
parameter  CLK_FREQ = 50000000;             //ϵͳʱ��Ƶ��
parameter  UART_BPS = 9600;                 //���ڲ�����
localparam BPS_CNT  = CLK_FREQ/UART_BPS;    //Ϊ�õ�ָ�������ʣ���ϵͳʱ�Ӽ���BPS_CNT��


reg[31:0] i;
reg [ 31:0] Data_Count;
parameter [ 31:0] Data_Len=32'd9;//�޸Ĵ˴�
reg [7:0] arry [Data_Len-1:0];



//reg define
reg        usart_down;
reg        uart_en_d0; 
reg        uart_en_d1;  
reg [15:0] clk_cnt;                         //ϵͳʱ�Ӽ�����
reg [ 3:0] tx_cnt;                          //�������ݼ�����
reg        tx_flag;                         //���͹��̱�־�ź�'b
reg [7:0]  tx_data;
reg        first;

wire en_flag;


initial begin   
    for(i=0; i<Data_Len; i=i+1'b1) begin    
    case(i)
      0: arry[0] = "j";
      1: arry[1] = "q";
      2: arry[2] = "w"; 
      3: arry[3] = "e"; 
      4: arry[4] = "r"; 
      5: arry[5] = "m"; 
      6: arry[6] = "n"; 
      7: arry[7] = "b"; 
      8: arry[8] = "v"; //�޸Ĵ˴�
      endcase
    end 
end 

//*****************************************************
//**                    main code
//*****************************************************
//����uart_en�����أ��õ�һ��ʱ�����ڵ������ź�
assign en_flag = (~uart_en_d1) & uart_en_d0;


always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        usart_down <= 1'b0;   
        first <= 1'b1; 
    end 
    else if (first)begin//����usart_down�ĵ�һ�������� firstʵ��
        usart_down <= 1;
        first <= 0;    
    end  
    else if(tx_cnt == 4'd0) begin                                      
        usart_down <= 1;      
    end
    else 
        usart_down <= 0; 
end


//usart_down�ı��ؼ��
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        uart_en_d0 <= 1'b0;
        uart_en_d1 <= 1'b0;          
    end
    else begin
        uart_en_d0  <= usart_down;                   
        uart_en_d1  <= uart_en_d0;
    end   
end



//�������ź�en_flag����ʱ,�Ĵ�����͵����ݣ������뷢�͹���          
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin                                  
        tx_flag <= 1'b0;
        tx_data <= arry[0];
        Data_Count <= 4'b0; 
    end 
    else if(en_flag) begin                 //��⵽����ʹ��������                      
        tx_flag <= 1'b1;                //���뷢�͹��̣���־λtx_flag����
        tx_data <= arry[Data_Count];            //�Ĵ�����͵�����
    end
    else  if((tx_cnt == 4'd10)&&(clk_cnt == BPS_CNT/2))
    begin                               //������ֹͣλ�м�ʱ��ֹͣ���͹���
        tx_flag <= 1'b0;                //���͹��̽�������־λtx_flag����
        Data_Count<=Data_Count+4'b1;
    if (Data_Count==Data_Len)
        Data_Count<=32'b0;      
    end
end



//���뷢�͹��̺�����ϵͳʱ�Ӽ������뷢�����ݼ�����
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin                             
        clk_cnt <= 16'd0;                                  
        tx_cnt  <= 4'd0;
    end                                                      
    else if (tx_flag) begin                 //���ڷ��͹���
        if (clk_cnt < BPS_CNT - 1) begin
            clk_cnt <= clk_cnt + 1'b1;
            tx_cnt  <= tx_cnt;
        end
        else begin
            clk_cnt <= 16'd0;               //��ϵͳʱ�Ӽ�����һ�����������ں�����
            tx_cnt  <= tx_cnt + 1'b1;       //��ʱ�������ݼ�������1
        end
    end
    else begin                              //���͹��̽���
        clk_cnt <= 16'd0;
        tx_cnt  <= 4'd0;
    end
end





//���ݷ������ݼ���������uart���Ͷ˿ڸ�ֵ
always @(posedge sys_clk or negedge sys_rst_n) begin        
    if (!sys_rst_n)  
        uart_txd <= 1'b1;        
    else if (tx_flag)
        case(tx_cnt)
            4'd0: uart_txd <= 1'b0;         //��ʼλ 
            4'd1: uart_txd <= tx_data[0];   //����λ���λ
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];   //����λ���λ
            4'd9: uart_txd <= 1'b1;         //ֹͣλ
            default: ;
        endcase
    else 
        uart_txd <= 1'b1;                   //����ʱ���Ͷ˿�Ϊ�ߵ�ƽ
end

endmodule	          
