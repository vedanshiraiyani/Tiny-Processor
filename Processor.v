`timescale 1ns / 1ps

module clock_div(input CLK, output slow_clk);
reg [31:0] counter=32'b0;
always @(posedge CLK)
begin
counter <= counter + 1;
end
assign slow_clk = counter[27];
endmodule




module merged(clk, pc_reset, reg_num, out, ACC, pc_disp);


input clk;
input pc_reset;
input [4:0] reg_num;
wire slow_clk;
output reg [7:0]out;
output reg [7:0]ACC;
output reg [6:0]pc_disp;


reg [3:0]pc;
reg [3:0]num;
reg [7:0]R[15:0];
reg [7:0]inst[15:0];
integer i;
reg [7:0] EXT;
reg [7:0] div, divisor;
reg [15:0] y;
reg c_b;
reg [7:0]op;
reg [3:0] op_code;
reg [3:0] inst_code;
    
initial begin
R[0] = 8'd0;
R[1] = 8'd10;  //after 1st test case value=6
R[2] = 8'd3;
R[3] = 8'd2;
R[4] = 8'd20;
R[5] = 8'd5;
R[6] = 8'd18;
R[7] = 8'd20;
R[8] = 8'd255;
R[9] = 8'd13;
R[10] = 8'd9;  //after 2nd test case value=254 (2's complement for -2)
R[11] = 8'd11;
R[12] = 8'd12;
R[13] = 8'd26;
R[14] = 8'd18;
R[15] = 8'd1;
end

initial begin
inst[0]=8'b10010101; //move R5 to ACC
inst[1]=8'b00100011; //sub R3 from ACC
inst[2]=8'b10101001; //move ACC to R9
inst[3]=8'b00000111; //dec ACC by 1
inst[4]=8'b00011110; //Add R14 to ACC
inst[5]=8'b01101110; //XOR ACC with R14
inst[6]=8'b00000110; //inc ACC by 1
inst[7]=8'b01000011; //Div ACC by R3
inst[8]=8'b00000010; //Right Shift ACC
inst[9]=8'b00000001; //left shift ACC
inst[10]=8'b10001101; //branch to 13
inst[11]=8'b00000011; //Circular right shift ACC
inst[12]=8'b00000100; //circular left shift ACC
inst[13]=8'b00000101; //Arithmatic shift right ACC
inst[14]=8'b00110111; //mul ACC with R7
inst[15]=8'b01011010; //AND ACC with R10


end



clock_div inst1(clk, slow_clk);

always @(posedge clk)begin
        if (pc_reset == 0) begin
            pc = 0;
        end else begin
            pc = pc + 1;
        end
        
        
        case (pc)
        4'h0: pc_disp = 7'b1000000;    // digit 0
        4'h1: pc_disp = 7'b1111001;    // digit 1
        4'h2: pc_disp = 7'b0100100;    // digit 2
        4'h3: pc_disp = 7'b0110000;    // digit 3
        4'h4: pc_disp = 7'b0011001;    // digit 4
        4'h5: pc_disp = 7'b0010010;    // digit 5
        4'h6: pc_disp = 7'b0000010;    // digit 6
        4'h7: pc_disp = 7'b1111000;    // digit 7
        4'h8: pc_disp = 7'b0000000;    // digit 8
        4'h9: pc_disp = 7'b0010000;    // digit 9
        4'ha: pc_disp = 7'b0001000;    // digit A
        4'hb: pc_disp = 7'b0000011;    // digit B
        4'hc: pc_disp = 7'b1000110;    // digit C
        4'hd: pc_disp = 7'b0100001;    // digit D
        4'he: pc_disp = 7'b0000110;    // digit E
        4'hf: pc_disp = 7'b0001110;    // digit F
        default:pc_disp=7'b1111111;
        endcase
        
        
        
//    end

//always@(posedge slow_clk)
//begin




op = inst[pc];


inst_code = op[7:4];
op_code = op[3:0];

if (op == 15) $finish();


else if (inst_code == 0)
    case(op_code)
    4'h1 : ACC <= ACC<<1;
    4'h2 : ACC <= ACC>>1;
    4'h3 : begin ACC <= ACC>>1; ACC[7] <= ACC[0]; end
    4'h4 : begin ACC <= ACC<<1; ACC[0] <= ACC[7]; end
    4'h5 : begin ACC <= ACC>>1; ACC[7] <= ACC[6]; end
    4'h6 : begin {c_b, ACC} <= ACC + 1; end
    4'h7 : begin {c_b, ACC} <= ACC - 1; end
    default : ACC <= ACC;
    endcase
    
    
    
else
begin  

case(inst_code)
    4'h1 : {c_b, ACC} <= ACC + R[op_code];
    4'h2 : {c_b, ACC} <= ACC - R[op_code];
    4'h3 : {EXT, ACC} <= ACC * R[op_code];
    4'h4 : begin
            div = ACC;
            divisor = R[op_code];
            ACC = 8'h00;
            EXT = 8'h00;
            for (i = 0; i<8; i = i+1)
                begin
                ACC = ACC << 1;
                y = {EXT, div};
                y = y << 1;
                EXT = y[15:8];
                div = y[7:0];
                if (EXT >= divisor)
                    begin
                    EXT  = EXT - divisor;
                    ACC[0] = 1;
                    end
                end
            end
    4'h5 : ACC <= (ACC & R[op_code]);
    4'h6 : ACC <= (ACC ^ R[op_code]);
    4'h7 : if (ACC < R[op_code]) c_b <= 1; else c_b <= 0;
    4'h8 : pc=op_code;
    4'h9 : ACC <= R[op_code];
    4'ha : R[op_code] <= ACC;
    4'hb : if (c_b) pc=op_code;
    default : ACC <= ACC;
    endcase
end 




if (reg_num<=15) out<=R[reg_num];
else if (reg_num==16) out<=EXT;
else if (reg_num==17) out<=c_b;
else out<=0;




end
endmodule
