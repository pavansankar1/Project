`timescale 1ns / 1ps

module rca_double_tb;
reg clk, init, test;
reg [3:0]a, b;
reg cin;
wire [3:0]at, bt;
wire cint;
wire [2:0]count;

wire [2:0]is0, is1;
wire [4:0]cs;
wire [3:0]ss0, ss1;

wire cout;
wire [3:0]sum;
wire [3:0] adder_sums, adder_carrys;

wire [7:0]comp;

rca2_tpg r2tpg(clk, init, test, at, bt, cint, count);
//rca_double r2d(is0, is1, cs, ss0, ss1, a, b, cin, test, at, bt, cint, sum, cout, adder_sums, adder_carrys);
rca_adj_faulty raf(is0, is1, cs, ss0, ss1, a, b, cin, test, at, bt, cint, sum, cout, adder_sums, adder_carrys);
rca2_lut r2lut2(count, adder_sums, adder_carrys, comp);
rca2_mul_sel_gen r2msg(clk, init, test, comp, is0, is1, cs, ss0, ss1);

//wire [4:0] test_muxa = raf.test_muxa;
//wire [4:0] test_muxb = raf.test_muxb;
always #5 clk = ~clk;
initial
begin
    //is = 0; cs = 5'b10000; ss = 0;
    test = 1;
    clk = 0;
    init = 1;
    #2 init = 0;
    #75
    test = 0;
    a=4'b1010; b=4'b0101; cin=0;
    #10 cin = 1;
    #10 $finish;
end

endmodule
