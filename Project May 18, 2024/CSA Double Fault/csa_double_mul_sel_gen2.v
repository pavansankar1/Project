`timescale 1ns / 1ps

module csa_double_mul_sel_gen2(clk, init, test, actual_output, desired_output, is0, is1, ss0, ss1, comp);
input clk, init, test;
input [29:0]actual_output;
input [5:0]desired_output;
output [2:0]is0, is1;
output [3:0] ss0, ss1;
output wire [4:0]comp;
reg [4:0]reg_out;
//Comparision
assign comp[0] = |(actual_output[5:0] ^ desired_output),
    comp[1] = |(actual_output[11:6] ^ desired_output),
    comp[2] = |(actual_output[17:12] ^ desired_output),
    comp[3] = |(actual_output[23:18] ^ desired_output),
    comp[4] = |(actual_output[29:24] ^ desired_output);

always @(posedge clk, posedge init, posedge test)
    if (init)
        reg_out <= 0;
    else if(test)
        reg_out <= reg_out | comp;
        
assign is0[0] = reg_out[0],
    is0[1] = reg_out[0] | reg_out[1],
    is0[2] = is0[1] | reg_out[2],
    
    ss0[0] = is0[0],
    ss0[1] = is0[1],
    ss0[2] = is0[2],
    ss0[3] = is0[2] | reg_out[3],
    
    is1[0] = reg_out[1] & is0[0],
    is1[1] = (reg_out[2] & is0[1]) | is1[0],
    is1[2] = (reg_out[3] & is0[2]) | is1[1],
    
    ss1[0] = is1[0],
    ss1[1] = is1[1],
    ss1[2] = is1[2],
    ss1[3] = (reg_out[4] & ss0[3]) | ss1[2];

endmodule
