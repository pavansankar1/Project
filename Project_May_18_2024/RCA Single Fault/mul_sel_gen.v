`timescale 1ns / 1ps

module mul_sel_gen(clk, init, test, comp, is, cs, ss);
input clk, init, test;
input [7:0]comp;
output [2:0]is;
output [4:0] cs;
output [3:0] ss;
reg [7:0]reg_out;
always @(posedge clk, posedge init, posedge test) 
    if (init)
        reg_out <= 0;
    else if(test)
        reg_out <= reg_out | comp;
        
assign fault0 = reg_out[0] | reg_out[4],
    fault1 = reg_out[1] | reg_out[5],
    fault2 = reg_out[2] | reg_out[6],
    fault3 = reg_out[3] | reg_out[7],
    
    is[0] = fault0,
    is[1] = is[0] | fault1,
    is[2] = is[1] | fault2,
    
    cs[0] = ~test & fault0,
    cs[1] = ~test & ~fault0 & fault1,
    cs[2] = ~test & ~fault1 & fault2,
    cs[3] = ~test & ~fault2 & fault3,
    cs[4] = ~test & (~fault0) & (~fault1) &(~fault2) &(~fault3),
    
    ss[0] = is[0],
    ss[1] = is[1],
    ss[2] = is[2],
    ss[3] = is[2] | fault3;
    
endmodule
