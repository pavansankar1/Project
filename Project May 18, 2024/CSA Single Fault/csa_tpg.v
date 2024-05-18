`timescale 1ns / 1ps

module csa_tpg(clk, init, test, test_data, desired_output);
input clk, init, test;
output [3:0]test_data;
output [5:0]desired_output;
wire c1_1, c1_0, s1_1, s1_0, s0_1, s0_0;
reg [1:0]count;
always @(posedge clk, posedge init)
    begin
    if (init)
        count <= 0;
    else
        count <= count + 1'b1;
    end
assign y1 = ~x1,
    x1 = count[1] ^ count[0],
    y0 = count[0],
    x0 = count[1],
    c1_1 = x1,
    c1_0 = ~(count[1] | count[0]),
    s1_1 = ~x1,
    s1_0 = count[1] | count[0],
    s0_1 = ~x1,
    s0_0 = x1;

assign test_data = {x1, y1, x0, y0};
assign desired_output = {c1_1, c1_0, s1_1, s1_0, s0_1, s0_0};
endmodule
