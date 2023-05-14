module step_control(
     input    [0:10]      in_step_num,
     input          sys_clk,
     input          sys_rst_n,
     input         step_move_en,//输入有效脉冲信号
     input       stepper_dir,
     output wire    stepper_step_out,//步进脉冲输出
     output         step_dir,//步进方向输出
     output         step_en,//步进en信号
     output     reg     step_end//步进结束信号
    
     
);

reg stepper_en;
reg          stepper_step;
reg   [23:0]  cnt;
reg   [22:0]  step_cnt;
reg   [3:0]   stpe_next;
reg   [3:0]   step_now;
wire        qr;//
//314step==5mm
wire [0:10] step_num ;//= 23'd500; //转动脉冲圈数具体情况具体给定 f= 250Hz 
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

//记脉冲数
always @(posedge stepper_step or negedge sys_rst_n) begin 
if(!sys_rst_n)
    begin
    stepper_en<=1'b1;
    step_cnt = 'd1;
    step_end<=1'b0;  //高电平有效
    end
else
    begin
        if( stpe_next == 3'b100 )
            begin 
            if(step_cnt == step_num) 
                begin
                step_cnt <= 23'd0;
                step_end <= 1'b1;//转动结束标志位
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
                stepper_en <= 1'b1;//清理使能标志位
                step_end <= 1'b0;
            end
            end
        else
            begin
            stepper_en <= 1'b1;//清理使能标志位
            step_end <= 1'b0;
            end
    end
end
// //只有当运动完成才能进行下一环节
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
// 状态机切换
always @(posedge sys_clk ) begin 
    case(step_now)
        3'b001: stpe_next <= 3'b010;//等待触发
        3'b010: stpe_next <= 3'b100;  //计数
        3'b100: stpe_next <= 3'b001;   //计数结束
        default: stpe_next <= 3'b001;
    endcase
end

always @(posedge sys_clk or negedge sys_rst_n ) begin 
//转换条件
if(!sys_rst_n)begin
step_now = 3'b001;

end
else    if( step_now == 3'b001 )                 //等待触发
        begin
            
            if(step_move_en)
                begin
                step_now <= stpe_next;
                end
            else
                step_now <= step_now;
        end
    else if( step_now == 3'b010 )             //计数
        begin 
        if(step_end == 1'b1 )
            begin
            step_now <= stpe_next;   //记满之后达到下一个状态
            end
        else
            begin                 
            step_now <= step_now;               //未记满时继续计数
            end
        end
    else if( step_now == 3'b100 )  begin           //转换结束
        step_now <= stpe_next;
        end
    else
        step_now <= 3'b001;
end


//定义时间计数器，t=
always@(posedge sys_clk or negedge sys_rst_n)
begin
	if(!sys_rst_n)
		cnt <= 1'b0;//当复位信号有效，计数器清零
	else 
	if(cnt < 24'd100_000/2)
			cnt <= cnt + 1'b1;//计数值加一
		else
			cnt <=24'd0;//当计数满时 cnt计数器清零
end
always@(posedge sys_clk or negedge sys_rst_n)
begin
	if(!sys_rst_n)
		stepper_step <= 1'b1;
	else 
		if(cnt == 24'd100_000/2)//微步时间 t=100_000*1/50_000_000=2ms T=4ms f=250hz  
		stepper_step <= ~stepper_step;//led移位流水
		else
			stepper_step <= stepper_step;
end
endmodule