`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/16 14:47:18
// Design Name: 
// Module Name: step_top
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


module step_top(
       sys_clk,
       sys_rst_n, 
       key,
       step_dir_A,
       step_en_A,
       step_pul_A,
       step_dir_B,
       step_en_B,
       step_pul_B,
    );
input sys_clk;
input sys_rst_n;
input key;
output step_dir_A;
output step_en_A;
output step_pul_A;
output step_dir_B;
output step_en_B;
output step_pul_B;
wire sys_clk;
wire sys_rst_n;
wire key;
wire step_dir_A;
wire step_en_A;
wire step_pul_A;
wire step_dir_B;
wire step_en_B;
wire step_pul_B;


wire key_value; 

reg [0:10]step_num;
key  u_key(
    .sys_clk(sys_clk),
    .sys_rst_n(sys_rst_n) ,
   
    .key(key),         //�ⲿ����İ���ֵ
    .key_value_out(key_value)      //������İ���ֵ��Ч��־
);
localparam IDLE        = 3'b000;
localparam UP_MOVE    =  3'b001;
localparam RIGHT_MOVE  = 3'b010;
localparam DOWN_MOVE    =  3'b011;
localparam RST_MOVE  =     3'b100;
reg [0:2] status;
 
reg stepper_dir_B;
reg stepper_dir_A;
reg step_move_en;

wire step_end_flag;
//CCDȷ����λ�ý���ץȡ-->��������-->�ﵽץȡλ�á���>ץȡ��Ϻ󡪡�>�����������¡���>�ﵽ���ð��ӵ�λ�á���>������Ϻ󡪡�>��������ȴ�CCDʶ��
//10:��
//01����
//00����
//11����
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if(!sys_rst_n)begin 
    step_num <= 11'd0;
    step_move_en <= 1'd0;
    stepper_dir_A <= 1'd0;
    stepper_dir_B <= 1'd0;
    status <= 3'd0;
end
    else 
        case(status)
        IDLE: if(key_value)begin  //CCDʶ��ɹ������ݴ���
                step_move_en <= 1'd1;
                status <= UP_MOVE;
                stepper_dir_A <= 1'd0 ;
                stepper_dir_B <= 1'd1 ;
                step_num <= 11'd100;
        end
              else begin
                status <=IDLE;
                step_move_en <= 1'd0;
              end
        UP_MOVE: if(step_end_flag)begin
                       step_move_en <= 1'd1;
                      status <= RIGHT_MOVE;
                      stepper_dir_A <= 1'd1 ;
                      stepper_dir_B <= 1'd0 ;
                      step_num <= 11'd100;
              end
                    else begin
                      step_move_en <= 1'd0;
                      status <=UP_MOVE;
                    end
        RIGHT_MOVE: if(step_end_flag)begin
                       step_move_en <= 1'd1;
                      status <= DOWN_MOVE;
                      stepper_dir_A <= 1'd1 ;
                      stepper_dir_B <= 1'd1 ;
                      step_num <= 11'd500;
              end
                    else begin
                      step_move_en <= 1'd0;
                      status <=RIGHT_MOVE;
                    end 
        DOWN_MOVE: if(step_end_flag)begin
                      step_move_en <= 1'd1;
                     status <= RST_MOVE;
                     stepper_dir_A <= 1'd0 ;
                     stepper_dir_B <= 1'd0 ;
                     step_num <= 11'd100;
             end
                   else begin
                     step_move_en <= 1'd0;
                     status <=DOWN_MOVE;
                   end
        RST_MOVE: if(step_end_flag)begin
                     step_move_en <= 1'd1;
                     status <= IDLE;
                     stepper_dir_A <= 1'd0 ;
                     stepper_dir_B <= 1'd0 ;
                     step_num <= 11'd500;
             end
                   else begin
                     step_move_en <= 1'd0;
                     status <=RST_MOVE;
                   end
         default :begin 
                status <= IDLE;
                end
       endcase      
end
wire step_end_A;
reg step_end_A_reg;
wire step_end_B;
reg step_end_B_reg;
assign step_end_flag = (!step_end_A&&step_end_A_reg)&&(step_end_B_reg&&!step_end_B);
always @(posedge sys_clk or negedge sys_rst_n) begin 
        if(!sys_rst_n)begin
         step_end_A_reg<= 1'd0;
         step_end_B_reg<= 1'd0;
        end
        else begin
        step_end_A_reg<= step_end_A;
        step_end_B_reg<= step_end_B;
        end 
        

end
step_control  A_step_control(
     .in_step_num(step_num),
     .sys_clk(sys_clk),
     .sys_rst_n(sys_rst_n),
     .step_move_en(step_move_en),//������Ч�����ź�
     .stepper_dir(stepper_dir_A),
     .stepper_step_out(step_pul_A),//�����������
     .step_dir(step_dir_A),//�����������
     .step_en(step_en_A),//����en�ź�
     .step_end(step_end_A)
);
step_control  B_step_control(
     .in_step_num(step_num),
     .sys_clk(sys_clk),
     .sys_rst_n(sys_rst_n),
     .step_move_en(step_move_en),//������Ч�����ź�
     .stepper_dir(stepper_dir_B),
     .stepper_step_out(step_pul_B),//�����������
     .step_dir(step_dir_B),//�����������
     .step_en(step_en_B),//����en�ź�
     .step_end(step_end_B)
);


     
endmodule