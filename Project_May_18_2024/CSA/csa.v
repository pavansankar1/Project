`timescale 1ns / 1ps

module csa(x, y, cin, sum, cout);
input [6:0]x, y;
input cin;
output [6:0]sum;
output cout;
wire [6:0]c1, c0, s1, s0;
genvar g;

generate 
for (g=0; g <= 6; g=g+1)
    begin : conditional_cell
    cc ccell(x[g], y[g], c1[g], c0[g], s1[g], s0[g]);
    end
endgenerate

wire [6:0]s1mux_s, s1mux_c;
wire [5:0]s2mux_s;
wire [2:0]s2mux_c;


assign s1mux_s[0] = cin? s1[0] : s0[0],
    s1mux_c[0] = cin? c1[0] : c0[0],
    
    s1mux_s[1] = c0[1]? s1[2] : s0[2],
    s1mux_c[1] = c0[1]? c1[2] : c0[2],
    s1mux_s[2] = c1[1]? s1[2] : s0[2],
    s1mux_c[2] = c1[1]? c1[2] : c0[2],
    
    s1mux_s[3] = c0[3]? s1[4] : s0[4],
    s1mux_c[3] = c0[3]? c1[4] : c0[4],
    s1mux_s[4] = c1[3]? s1[4] : s0[4],
    s1mux_c[4] = c1[3]? c1[4] : c0[4],
    
    s1mux_s[5] = c0[5]? s1[6] : s0[6],
    s1mux_c[5] = c0[5]? c1[6] : c0[6],
    s1mux_s[6] = c1[5]? s1[6] : s0[6],
    s1mux_c[6] = c1[5]? c1[6] : c0[6];
    
assign s2mux_s[0] = s1mux_c[0]? s1[1] : s0[1],
    s2mux_s[1] = s1mux_c[0]? s1mux_s[2] : s1mux_s[1],
    s2mux_c[0] = s1mux_c[0]? s1mux_c[2] : s1mux_c[1],
    
    s2mux_s[2] = s1mux_c[3]? s1[5] : s0[5],
    s2mux_s[3] = s1mux_c[3]? s1mux_s[6] : s1mux_s[5],
    s2mux_c[1] = s1mux_c[3]? s1mux_c[6] : s1mux_c[5],
    
    s2mux_s[4] = s1mux_c[4]? s1[5] : s0[5],
    s2mux_s[5] = s1mux_c[4]? s1mux_s[6] : s1mux_s[5],
    s2mux_c[2] = s1mux_c[4]? s1mux_c[6] : s1mux_c[5],
    
    sum[0] = s1mux_s[0],
    sum[1] = s2mux_s[0],
    sum[2] = s2mux_s[1],
    sum[3] = s2mux_c[0]? s1[3] : s0[3],
    sum[4] = s2mux_c[0]? s1mux_s[4] : s1mux_s[3],
    sum[5] = s2mux_c[0]? s2mux_s[4] : s2mux_s[2],
    sum[6] = s2mux_c[0]? s2mux_s[5] : s2mux_s[3],
    cout = s2mux_c[0]? s2mux_c[2] : s2mux_c[1];
    
endmodule
/*
module cc(x, y, c1, c0, s1, s0);
input x, y;
output  c1, c0, s1, s0;
assign c1 = x | y,
    c0 = x & y,
    s1 = x ~^ y,
    s0 = x ^ y;
endmodule
*/