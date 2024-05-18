`timescale 1ns / 1ps

module csa_mul_sel_gen(clk, init, test, actual_output, desired_output, is, ss, comp);
input clk, init, test;
input [23:0]actual_output;
input [5:0]desired_output;
output [2:0]is;
output [3:0] ss;
reg [3:0]reg_out;
output wire [3:0]comp;
//Comparision
assign comp[0] = |(actual_output[5:0] ^ desired_output),
    comp[1] = |(actual_output[11:6] ^ desired_output),
    comp[2] = |(actual_output[17:12] ^ desired_output),
    comp[3] = |(actual_output[23:18] ^ desired_output);

always @(posedge clk, posedge init, posedge test)
    if (init)
        reg_out <= 0;
    else if(test)
        reg_out <= reg_out | comp;
        
assign is[0] = reg_out[0],
    is[1] = reg_out[0] | reg_out[1],
    is[2] = is[1] | reg_out[2],
    
    ss[0] = is[0],
    ss[1] = is[1],
    ss[2] = is[2],
    ss[3] = is[2] | reg_out[3];
endmodule
