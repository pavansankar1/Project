`timescale 1ns / 1ps

module rca_adj_faulty(is0, is1, cs, ss0, ss1, a, b, cin, test, at, bt, cint, sum, cout, adder_sums, adder_carrys);
input wire [3:0]a, b;
input wire [3:0]at, bt;
input wire test, cin, cint;
input wire [2:0]is0, is1;
input wire [4:0]cs;
input wire [3:0]ss0, ss1;
output wire [3:0] sum;
output wire cout;
output wire [3:0]adder_sums, adder_carrys;

wire [3:0] test_muxa, test_muxb;
wire test_muxcin;
wire [2:0] s0_ina, s0_inb, s1_ina, s1_inb;
wire [5:0]s0_carry;
wire [4:0]s0_sum;
wire [5:0]fa_sum, fa_carry;
//Adder Outputs for Testing
assign adder_sums = fa_sum[3:0], adder_carrys = fa_carry[3:0];

//Stage 0 Input Selection
assign s0_ina[0] = is0[0]? a[0] : a[1],
    s0_inb[0] = is0[0]? b[0] : b[1],
    s0_ina[1] = is0[1]? a[1] : a[2],
    s0_inb[1] = is0[1]? b[1] : b[2],
    s0_ina[2] = is0[2]? a[2] : a[3],
    s0_inb[2] = is0[2]? b[2] : b[3];
//Stage 1 Input Selection
assign s1_ina[0] = is1[0]? s0_ina[0] : s0_ina[1],
    s1_inb[0] = is1[0]? s0_inb[0] : s0_inb[1],
    s1_ina[1] = is1[1]? s0_ina[1] : s0_ina[2],
    s1_inb[1] = is1[1]? s0_inb[1] : s0_inb[2],
    s1_ina[2] = is1[2]? s0_ina[2] : a[3],
    s1_inb[2] = is1[2]? s0_inb[2] : b[3];

//Test Input Selection
assign //test_muxa = test? at : {s1_ina[1], s1_ina[0], s0_ina[0], a[0]},
    test_muxa = test? {at[3], 1'b1, 1'b0, at[0]} : {s1_ina[1],  1'b1, 1'b0, a[0]},
    test_muxb = test? bt : {s1_inb[1], s1_inb[0], s0_inb[0], b[0]},
    test_muxcin = test? cint : cin;

//Stage 0 Carry Selection
assign s0_carry[0] = cs[0]? test_muxcin : fa_carry[1],
    s0_carry[1] = cs[1]? fa_carry[0] : fa_carry[2],
    s0_carry[2] = cs[2]? fa_carry[1] : fa_carry[3],
    s0_carry[3] = cs[3]? fa_carry[2] : fa_carry[4],
    s0_carry[4] = cs[4]? fa_carry[3] : fa_carry[5],
    cout = s0_carry[4];

//Full Adders
fulladder fa0(test_muxa[0], test_muxb[0], test_muxcin, fa_sum[0], fa_carry[0]);
fulladder fa1(test_muxa[1], test_muxb[1], fa_carry[0], fa_sum[1], fa_carry[1]);
fulladder fa2(test_muxa[2], test_muxb[2], s0_carry[0], fa_sum[2], fa_carry[2]);
fulladder fa3(test_muxa[3], test_muxb[3], s0_carry[1], fa_sum[3], fa_carry[3]);
fulladder fa4(s1_ina[2], s1_inb[2], s0_carry[2], fa_sum[4], fa_carry[4]);
fulladder fa5(a[3], b[3], s0_carry[3], fa_sum[5], fa_carry[5]);

//Stage 0 Output Selection
assign s0_sum[0] = ss0[0]? fa_sum[1] : fa_sum[0],
    s0_sum[1] = ss0[1]? fa_sum[2] : fa_sum[1],
    s0_sum[2] = ss0[2]? fa_sum[3] : fa_sum[2],
    s0_sum[3] = ss0[3]? fa_sum[4] : fa_sum[3];
//Stage 1 Output Selection
assign sum[0] = ss1[0]? s0_sum[1] : s0_sum[0],
    sum[1] = ss1[1]? s0_sum[2] : s0_sum[1],
    sum[2] = ss1[2]? s0_sum[3] : s0_sum[2],
    sum[3] = ss1[3]? fa_sum[5] : s0_sum[3];
endmodule

