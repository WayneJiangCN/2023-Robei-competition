
module uart_send(
    sys_clk,                  //ϵͳʱ��
    sys_rst_n,                //ϵͳ��λ���͵�ƽ��Ч
    uart_en,                    //full->uart_en
    data_128_en,
    uart_din,
    empty,
    uart_txd,               //UART���Ͷ˿�
    uart_tx_flag
    );
    
input sys_clk;
input sys_rst_n;
input uart_en;
input data_128_en;
input empty;
input uart_din;
output uart_txd;
output uart_tx_flag;

wire sys_clk;
wire sys_rst_n;
wire uart_en;
wire data_128_en;
wire [7:0] uart_din;
wire empty;
reg uart_txd;
    
//parameter define
parameter  CLK_FREQ = 50000000;             //ϵͳʱ��Ƶ��
parameter  UART_BPS = 115200;                 //���ڲ�����
localparam BPS_CNT  = CLK_FREQ/UART_BPS;    //Ϊ�õ�ָ�������ʣ���ϵͳʱ�Ӽ���BPS_CNT��




//reg define
//reg        usart_down;
reg        uart_en_d0; 
reg        uart_en_d1;  
reg [15:0] clk_cnt;                         //ϵͳʱ�Ӽ�����
reg [ 3:0] tx_cnt;                          //�������ݼ�����
reg        tx_flag;                         //���͹��̱�־�ź�'b
reg [7:0]  tx_data;
reg        first;
//reg [ 31:0] Data_Count;

//wire define
wire       en_flag;

//parameter [ 31:0] Data_Len=32'd11;//�޸Ĵ˴�
//reg[31:0] i;
//reg [7:0] arry [Data_Len-1:0];
//initial begin   
//    for(i=0; i<Data_Len; i=i+1'b1) begin    
//    case(i)
//      0: arry[0] = "d";
//      1: arry[1] = "a";
//      2: arry[2] = "t"; 
//      3: arry[3] = "a"; 
//      4: arry[4] = "i"; 
//      5: arry[5] = "s"; 
//      6: arry[6] = " ";       
//      7: arry[7] = " "; 
//      8: arry[8] = " "; //�޸Ĵ˴�
//      9: arry[9] = 13; //\r
//      10: arry[10] = 10; //\n
//      endcase
//    end 
//end 
//always @(posedge sys_clk or negedge sys_rst_n) begin 
//    if(!sys_rst_n)begin
//    end
//    else if(uart_en)begin
//    arry[8] =  uart_din%10+6'd48;
//    arry[7] =  uart_din/10%10+6'd48; 
//    arry[6] =  uart_din/100+6'd48; 
//    end  
//end
//*****************************************************
//**                    main code
//*****************************************************
//����uart_en�����أ��õ�һ��ʱ�����ڵ������ź�
assign en_flag = (uart_en_d1) & (~uart_en_d0);


//always @(posedge sys_clk or negedge sys_rst_n) begin         
//    if (!sys_rst_n) begin
//        usart_down <= 1'b0;   
//        first <= 1'b1; 
//    end 
//    else if (first)begin//����usart_down�ĵ�һ�������� firstʵ��
//        usart_down <= 1;
//        first <= 0;    
//    end  
//    else if(tx_cnt == 4'd0) begin                                      
//        usart_down <= 1;      
//    end
//    else 
//        usart_down <= 0; 
//end


//usart_en�ı��ؼ��
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        uart_en_d0 <= 1'b0;
        uart_en_d1 <= 1'b0;          
    end
    else begin
        uart_en_d0  <= uart_en;                   
        uart_en_d1  <= uart_en_d0;
    end   
end


reg ff_flag;
reg isDone;
wire uart_tx_flag;
reg tx_flag_reg;
assign uart_tx_flag = (~tx_flag)&&tx_flag_reg;
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        tx_flag_reg <= 1'b0;
    end
    else
        tx_flag_reg <= tx_flag;
end

//�������ź�en_flag����ʱ,�Ĵ�����͵����ݣ������뷢�͹���          
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin                                  
        tx_flag <= 1'b0;
        //ff_flag <= 1'b0;
        tx_data <= 8'd0;
        //Data_Count <= 4'b0; 
    end 
    else if(en_flag||data_128_en) begin                 //��⵽����ʹ��������  
       // if(count>8'd3&&count<8'd132)begin                    
        tx_flag <= 1'b1;                //���뷢�͹��̣���־λtx_flag����
        tx_data <= uart_din;            //�Ĵ�����͵�����
       // ff_flag <= 1'b1;
       // end
    end
//     else if(empty)begin
//   //  ff_flag <= 1'b0;
//     tx_flag <= 1'b1;                //���뷢�͹��̣���־λtx_flag����
//    tx_data <= 8'b11111111 ;            //�Ĵ�����͵�����
//   end
    else  if((tx_cnt == 4'd10)&&(clk_cnt == BPS_CNT/2))
    begin                               //������ֹͣλ�м�ʱ��ֹͣ���͹���
        tx_flag <= 1'b0;                //���͹��̽�������־λtx_flag����
//        Data_Count<=Data_Count+4'b1;
//    if (Data_Count==Data_Len)
//        Data_Count<=32'b0;      
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
    if (!sys_rst_n)begin  
        uart_txd <= 1'b1;   
        isDone <= 1'd1;
        end     
    else if (tx_flag)
        case(tx_cnt)
            4'd0: begin uart_txd <= 1'b0;       end  //��ʼλ 
            4'd1: uart_txd <= tx_data[0];   //����λ���λ
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];   //����λ���λ
            4'd9: begin uart_txd <= 1'b1;     isDone <= 1'd1;end    //ֹͣλ
            default: ;
        endcase
    else 
        uart_txd <= 1'b1;                   //����ʱ���Ͷ˿�Ϊ�ߵ�ƽ
end
//assign TX_Done = isDone;
endmodule	          
