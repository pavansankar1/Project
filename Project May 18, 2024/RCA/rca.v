`timescale 1ns / 1ps

module rca(a, b, cin, sum, cout);
input [3:0]a, b;
input cin;
output [3:0] sum;
output cout;
wire [2:0] carry;

fulladder fa0(a[0], b[0], cin, sum[0], carry[0]);
fulladder fa1(a[1], b[1], carry[0], sum[1], carry[1]);
fulladder fa2(a[2], b[2], carry[1], sum[2], carry[2]);
fulladder fa3(a[3], b[3], carry[2], sum[3], cout);
endmodule

/*
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
*/