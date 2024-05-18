`timescale 1ns / 1ps

module rca_reconfig_tb;
reg clk, init, test;
reg [3:0]a, b;
reg cin;
wire [3:0]at, bt;
wire cint;
wire [2:0]count;

wire [2:0]is;
wire [4:0]cs;
wire [3:0]ss;

wire cout;
wire [3:0]sum;
wire [3:0] adder_sums, adder_carrys;

wire [7:0]comp;

tpg tpg2(clk, init, test, at, bt, cint, count);
//rca_reconfig rft2(is, cs, ss, a, b, cin, test, at, bt, cint, sum, cout, adder_sums, adder_carrys);
rca_faulty rft3(is, cs, ss, a, b, cin, test, at, bt, cint, sum, cout, adder_sums, adder_carrys);
lut lut2(count, adder_sums, adder_carrys, comp);
mul_sel_gen msg(clk, init, test, comp, is, cs, ss);

always #5 clk = ~clk;
initial
begin
    //Test Mode
    test = 1;
    clk = 0;
    init = 1;
    #2 init = 0;
    #75
    //Normal Mode
    test = 0;
    a=4'b1010; b=4'b0101; cin=0;
    #10 cin = 1;
    #10 $finish;
end

endmodule
