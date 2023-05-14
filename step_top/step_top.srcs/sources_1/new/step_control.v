module step_control(
     input    [0:10]      in_step_num,
     input          sys_clk,
     input          sys_rst_n,
     input         step_move_en,//������Ч�����ź�
     input       stepper_dir,
     output wire    stepper_step_out,//�����������
     output         step_dir,//�����������
     output         step_en,//����en�ź�
     output     reg     step_end//���������ź�
    
     
);

reg stepper_en;
reg          stepper_step;
reg   [23:0]  cnt;
reg   [22:0]  step_cnt;
reg   [3:0]   stpe_next;
reg   [3:0]   step_now;
wire        qr;//
//314step==5mm
wire [0:10] step_num ;//= 23'd500; //ת������Ȧ���������������� f= 250Hz 
assign step_num = in_step_num;
//parameter step_num = 23'd17;
reg led_guangdian_0;

assign stepper_step_out =stepper_step && (~stepper_en);
assign qr = stepper_en;
assign step_dir = stepper_dir;
assign step_en = stepper_en;

//  ila_0  u_ila_0(
//     .clk(sys_clk), // input wire clk
//     .probe0(step_now),
//     .probe1(stpe_next),
//     .probe2(step_move_en),
//     .probe3(step_cnt),
//     .probe4(step_end),
//     .probe5(step_en)
    
    
// );   
// delay u_delay(
//      .sys_clk(sys_clk),
//      .sys_rst_n(sys_rst_n),
//      .delay_clk_out(delay_clk)
//     );

//��������
always @(posedge stepper_step or negedge sys_rst_n) begin 
if(!sys_rst_n)
    begin
    stepper_en<=1'b1;
    step_cnt = 'd1;
    step_end<=1'b0;  //�ߵ�ƽ��Ч
    end
else
    begin
        if( stpe_next == 3'b100 )
            begin 
            if(step_cnt == step_num) 
                begin
                step_cnt <= 23'd0;
                step_end <= 1'b1;//ת��������־λ
                stepper_en <= 1'b1;
                end
            else if(step_cnt<step_num)
                begin
                stepper_en <= 1'b0;
                step_cnt <= step_cnt +1'b1;
                step_end <= 1'b0;
                end
            else
            begin
                step_cnt <= 23'd0;
                stepper_en <= 1'b1;//����ʹ�ܱ�־λ
                step_end <= 1'b0;
            end
            end
        else
            begin
            stepper_en <= 1'b1;//����ʹ�ܱ�־λ
            step_end <= 1'b0;
            end
    end
end
// //ֻ�е��˶���ɲ��ܽ�����һ����
// always@(posedge delay_clk )
// begin
//     if(guangdian==1&&step_end==1)
//     begin
//         led_guangdian<=1'b1;
//         led_guangdian_0<=led_guangdian;
//         end
//     else
//     begin
//         led_guangdian<=1'b0;
//         led_guangdian_0<=led_guangdian;
//         end
// end 
// ״̬���л�
always @(posedge sys_clk ) begin 
    case(step_now)
        3'b001: stpe_next <= 3'b010;//�ȴ�����
        3'b010: stpe_next <= 3'b100;  //����
        3'b100: stpe_next <= 3'b001;   //��������
        default: stpe_next <= 3'b001;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n ) begin 
//ת������
if(!sys_rst_n)begin
step_now = 3'b001;

end
else    if( step_now == 3'b001 )                 //�ȴ�����
        begin
            
            if(step_move_en)
                begin
                step_now <= stpe_next;
                end
            else
                step_now <= step_now;
        end
    else if( step_now == 3'b010 )             //����
        begin 
        if(step_end == 1'b1 )
            begin
            step_now <= stpe_next;   //����֮��ﵽ��һ��״̬
            end
        else
            begin                 
            step_now <= step_now;               //δ����ʱ��������
            end
        end
    else if( step_now == 3'b100 )  begin           //ת������
        step_now <= stpe_next;
        end
    else
        step_now <= 3'b001;
end


//����ʱ���������t=
always@(posedge sys_clk or negedge sys_rst_n)
begin
	if(!sys_rst_n)
		cnt <= 1'b0;//����λ�ź���Ч������������
	else 
	if(cnt < 24'd100_000/2)
			cnt <= cnt + 1'b1;//����ֵ��һ
		else
			cnt <=24'd0;//��������ʱ cnt����������
end
always@(posedge sys_clk or negedge sys_rst_n)
begin
	if(!sys_rst_n)
		stepper_step <= 1'b1;
	else 
		if(cnt == 24'd100_000/2)//΢��ʱ�� t=100_000*1/50_000_000=2ms T=4ms f=250hz  
		stepper_step <= ~stepper_step;//led��λ��ˮ
		else
			stepper_step <= stepper_step;
end
endmodule