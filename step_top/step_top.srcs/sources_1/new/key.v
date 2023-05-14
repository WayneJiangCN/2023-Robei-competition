//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           key_debounce
// Last modified Date:  2019/4/14 16:23:36
// Last Version:        V1.0
// Descriptions:        ��������
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/4/14 16:23:36
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
// Modified by:		    ����ԭ��
// Modified date:
// Version:
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module key(
    input        sys_clk ,
    input        sys_rst_n ,


    input        key ,         //�ⲿ����İ���ֵ
    output   key_value_out      //������İ���ֵ��Ч��־
);
reg key_value;

//reg define
reg [19:0] cnt ;
reg        key_reg ;
reg key_flag;
wire  key_en;   //������İ���ֵ
//*****************************************************
//**                    main code
//*****************************************************

//����ֵ����
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt <= 20'd0;
        key_reg <= 1'b1;
    end
    else begin
        key_reg <= key;           //������ֵ�ӳ�һ��
        if(key_reg != key) begin  //�����ǰ����ֵ��ǰһ�ĵİ���ֵ��һ���������������»��ɿ�
            cnt <= 20'd10;  //�򽫼�������Ϊ20'd100_0000��
                                  //����ʱ100_0000 * 20ns(1s/50MHz) = 20ms
        end
        else begin                //�����ǰ����ֵ��ǰһ������ֵһ����������û�з����仯
            if(cnt > 20'd0)       //��������ݼ���0
                cnt <= cnt - 1'b1;  
            else
                cnt <= 20'd0;
        end
    end
end

//������������յİ���ֵ�ͳ�ȥ
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        key_value <= 1'b1;
        key_flag  <= 1'b0;
    end
	//�ڼ������ݼ���1ʱ�ͳ�����ֵ
    else if(cnt == 20'd1) begin
		key_value <= key;
		key_flag  <= 1'b1;
		//led <= ~led;
        end
    else begin
		key_value <= key_value;
		key_flag  <= 1'b0;
		//led <= led;
    end
end

reg key_flag_reg;

always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
    key_flag_reg = 'd0;
    end
    else
        key_flag_reg = key_flag;

end
assign key_en =  key_flag_reg&&(!key_flag);
assign    key_value_out    =key_flag&&(~key_value);

endmodule
