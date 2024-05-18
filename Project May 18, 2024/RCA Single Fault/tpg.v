`timescale 1ns / 1ps

module tpg(clk, init, test, at, bt, cint, count);
input clk, init, test;
output reg [2:0]count;
output [3:0]at, bt;
output cint;

always @(posedge clk, posedge init)
    begin
    if (init)
        count <= 0;
    else
        count <= count + 1'b1;
    end
assign cint = (count[0]|count[1]) ~^ count[2],
bt[0] = count[0],
at[0] = count[1],
bt[1] = count[0] ~^ count[2],
at[1] = count[1] ~^ count[2],
bt[2] = count[0],
at[2] = count[1],
bt[3] = bt[1],
at[3] = at[1];

endmodule
