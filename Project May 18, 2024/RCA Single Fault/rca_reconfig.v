`timescale 1ns / 1ps

module rca_reconfig(is, cs, ss, a, b, cin, test, at, bt, cint, sum, cout, adder_sums, adder_carrys);
input [3:0]a, b;
input [3:0]at, bt;
input test, cin, cint;
input [2:0]is;
input [4:0]cs;
input [3:0]ss;
output [3:0] sum;
output cout;
output wire [3:0]adder_sums, adder_carrys;

wire [3:0] muxa, muxb;
wire muxcin;
wire [2:0] ina, inb;
wire [3:0]mux_carry;
wire [4:0]fa_sum, fa_carry;
//Adder Outputs for Testing
assign adder_sums = fa_sum[3:0], adder_carrys = fa_carry[3:0];
//Input Selection
assign ina[0] = is[0]? a[0] : a[1],
    inb[0] = is[0]? b[0] : b[1],
    ina[1] = is[1]? a[1] : a[2],
    inb[1] = is[1]? b[1] : b[2],
    ina[2] = is[2]? a[2] : a[3],
    inb[2] = is[2]? b[2] : b[3];
//Carry Selection
assign mux_carry[0] = cs[0]? muxcin : fa_carry[0],
    mux_carry[1] = cs[1]? fa_carry[0] : fa_carry[1],
    mux_carry[2] = cs[2]? fa_carry[1] : fa_carry[2],
    mux_carry[3] = cs[3]? fa_carry[2] : fa_carry[3],
    cout = cs[4]? fa_carry[3] : fa_carry[4];

//Test Input Selection
assign muxa = test? at : {ina[2], ina[1], ina[0], a[0]},
    muxb = test? bt : {inb[2], inb[1], inb[0], b[0]},
    muxcin = test? cint : cin;

//Adders
fulladder fa0(muxa[0], muxb[0], muxcin, fa_sum[0], fa_carry[0]);
fulladder fa1(muxa[1], muxb[1], mux_carry[0], fa_sum[1], fa_carry[1]);
fulladder fa2(muxa[2], muxb[2], mux_carry[1], fa_sum[2], fa_carry[2]);
fulladder fa3(muxa[3], muxb[3], mux_carry[2], fa_sum[3], fa_carry[3]);
fulladder fa4(a[3], b[3], mux_carry[3], fa_sum[4], fa_carry[4]);

//Output Selection
assign sum[0] = ss[0]? fa_sum[1] : fa_sum[0],
    sum[1] = ss[1]? fa_sum[2] : fa_sum[1],
    sum[2] = ss[2]? fa_sum[3] : fa_sum[2],
    sum[3] = ss[3]? fa_sum[4] : fa_sum[3];
endmodule

//Full Adder Module
module fulladder(a, b, cin, sum, carry);
input a, b, cin;
output sum, carry;
wire w1,w2,w3;
xor x1(w1, a, b);
xor x2(sum, w1, cin);
and a3(w2, w1, cin);
and a4(w3, a, b);
or o5(carry, w2, w3);
endmodule