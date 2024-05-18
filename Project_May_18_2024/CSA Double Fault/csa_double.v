`timescale 1ns / 1ps

module csa_double(is0, is1, ss0, ss1, x, y, cin, test, test_data, sum, cout, actual_output);
input [2:0]is0, is1;
input [3:0]ss0, ss1;
input [6:0] x, y;
input cin, test;
input [3:0]test_data;
output [6:0]sum;
output cout;
output wire [29:0]actual_output;

wire [3:0]actual_data[0:3];

wire [6:0]s1mux_s, s1mux_c;
wire [5:0]s2mux_s;
wire [2:0]s2mux_c;

wire [3:0] s0_input[0:2];
wire [3:0] s1_input[0:2];
wire [3:0]test_mux[0:4];
wire [5:0]csc_out[0:5];
wire [5:0]s0_output[0:3];
wire [5:0]s1_output[0:3];
wire s1_1, s1_0, s3_1, s3_0, s5_1, s5_0;

//Test output 
assign actual_output = {csc_out[4], csc_out[3], csc_out[2], csc_out[1], csc_out[0]};
//Actual Input
assign actual_data[0] = {x[0], y[0], cin, 1'b0},
    actual_data[1] = {x[2], y[2], x[1], y[1]},
    actual_data[2] = {x[4], y[4], x[3], y[3]},
    actual_data[3] = {x[6], y[6], x[5], y[5]};

//Stage 0 Input Selection
assign s0_input[0] = is0[0]? actual_data[0] : actual_data[1],
    s0_input[1] = is0[1]? actual_data[1] : actual_data[2],
    s0_input[2] = is0[2]? actual_data[2] : actual_data[3];
//Stage 1 Input Selection
assign s1_input[0] = is1[0]? s0_input[0] : s0_input[1],
    s1_input[1] = is1[1]? s0_input[1] : actual_data[2],
    s1_input[2] = is1[2]? s0_input[2] : actual_data[3];
//Test Input Selection
assign test_mux[0] = test? test_data : actual_data[0],
    test_mux[1] = test? test_data : s0_input[0],
    test_mux[2] = test? test_data : s1_input[0],
    test_mux[3] = test? test_data : s1_input[1],
    test_mux[4] = test? test_data : s1_input[2];
    
//Adders
csc csc0(test, test_mux[0], csc_out[0]);
csc csc1(test, test_mux[1], csc_out[1]);
csc csc2(test, test_mux[2], csc_out[2]);
csc csc3(test, test_mux[3], csc_out[3]);
csc csc4(test, test_mux[4], csc_out[4]);
csc csc5(test, actual_data[3], csc_out[5]);

//Stage 0 Output Selection
assign s0_output[0] = ss0[0]? csc_out[1] : csc_out[0],
    s0_output[1] = ss0[1]? csc_out[2] : csc_out[1],
    s0_output[2] = ss0[2]? csc_out[3] : csc_out[2],
    s0_output[3] = ss0[3]? csc_out[4] : csc_out[3];
//Stage 1 Output Selection
assign s1_output[0] = ss1[0]? s0_output[1] : s0_output[0],
    s1_output[1] = ss1[1]? s0_output[2] : s0_output[1],
    s1_output[2] = ss1[2]? s0_output[3] : s0_output[2],
    s1_output[3] = ss1[3]? csc_out[5] : s0_output[3];
//First Stage Final Outputs
assign {s1mux_c[0], s1mux_s[0]} = {s1_output[0][5],s1_output[0][3]},
    {s1mux_c[2:1], s1mux_s[2:1], s1_1, s1_0 } = s1_output[1],
    {s1mux_c[4:3], s1mux_s[4:3], s3_1, s3_0 } = s1_output[2],
    {s1mux_c[6:5], s1mux_s[6:5], s5_1, s5_0 } = s1_output[3];
//Second Stage Outputs
assign s2mux_s[0] = s1mux_c[0]? s1_1 : s1_0,
    s2mux_s[1] = s1mux_c[0]? s1mux_s[2] : s1mux_s[1],
    s2mux_c[0] = s1mux_c[0]? s1mux_c[2] : s1mux_c[1],
    
    s2mux_s[2] = s1mux_c[3]? s5_1 : s5_0,
    s2mux_s[3] = s1mux_c[3]? s1mux_s[6] : s1mux_s[5],
    s2mux_c[1] = s1mux_c[3]? s1mux_c[6] : s1mux_c[5],
    
    s2mux_s[4] = s1mux_c[4]? s5_1 : s5_0,
    s2mux_s[5] = s1mux_c[4]? s1mux_s[6] : s1mux_s[5],
    s2mux_c[2] = s1mux_c[4]? s1mux_c[6] : s1mux_c[5],
//Third Stage Muxes and Output    
    sum[0] = s1mux_s[0],
    sum[1] = s2mux_s[0],
    sum[2] = s2mux_s[1],
    sum[3] = s2mux_c[0]? s3_1 : s3_0,
    sum[4] = s2mux_c[0]? s1mux_s[4] : s1mux_s[3],
    sum[5] = s2mux_c[0]? s2mux_s[4] : s2mux_s[2],
    sum[6] = s2mux_c[0]? s2mux_s[5] : s2mux_s[3],
    cout = s2mux_c[0]? s2mux_c[2] : s2mux_c[1];
    
endmodule

module cc(x, y, c1, c0, s1, s0);
input x, y;
output  c1, c0, s1, s0;
assign c1 = x | y,
    c0 = x & y,
    s1 = x ~^ y,
    s0 = x ^ y;
endmodule

module ccm(test, x, y, c1, c0, s1, s0);
input x, y, test;
output  c1, c0, s1, s0;
assign c1 = (x & y & test) ^ (x | y),
    c0 = (x & y) ^ (s1 & test),
    s1 = x ~^ y,
    s0 = x ^ y;
endmodule

module csc(test, csc_in, csc_out);
input test;
input [3:0]csc_in;
output [5:0] csc_out;

wire c1_1, c1_0, s1_1, s1_0, s0_1, s0_0;
wire c0_1, c0_0, tc1_1, tc1_0, ts1_1, ts1_0;
wire x1, y1, x0, y0;
assign {x1, y1, x0, y0} = csc_in;
ccm ccm0(test, x0, y0, c0_1, c0_0, s0_1, s0_0);
ccm ccm1(test, x1, y1, tc1_1, tc1_0, ts1_1, ts1_0);

assign {c1_1, s1_1} = c0_1? {tc1_1, ts1_1} : {tc1_0, ts1_0};
assign {c1_0, s1_0} = c0_0? {tc1_1, ts1_1} : {tc1_0, ts1_0};
assign csc_out = {c1_1, c1_0, s1_1, s1_0, s0_1, s0_0};
endmodule
