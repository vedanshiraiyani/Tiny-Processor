`timescale 1ns / 1ps


module tb();

reg clk;
reg pc_reset;
reg [4:0] reg_num;
wire [7:0]out;
wire [7:0]ACC;
wire [6:0]pc_disp;

merged uut (clk, pc_reset, reg_num, out, ACC, pc_disp);
initial
begin
    clk = 0;
    forever #5 clk = ~clk;
end
initial
begin
    pc_reset=0; #10;
    pc_reset=1; 
    
    #500;
$finish();
end
endmodule
