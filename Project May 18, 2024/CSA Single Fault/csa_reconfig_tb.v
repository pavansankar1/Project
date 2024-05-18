`timescale 1ns / 1ps

module csa_reconfig_tb;
wire [2:0]is;
wire [3:0]ss;
wire [3:0]comp;
reg [6:0] x, y;
reg cin, clk, init, test;

wire [6:0]sum;
wire cout;
wire [5:0]desired_output;
wire [3:0]test_data;
wire [23:0]actual_output;

//csa_reconfig csar(is, ss, x, y, cin, test, test_data, sum, cout, actual_output);
csa_faulty csaf(is, ss, x, y, cin, test, test_data, sum, cout, actual_output);
csa_tpg csatpg(clk, init, test, test_data, desired_output);
csa_mul_sel_gen csamsg(clk, init, test, actual_output, desired_output, is, ss, comp);

always #5 clk = ~clk;
initial
    begin
    //is=0; ss=0;
    test = 1;
    clk = 0;
    init = 1;
    #2 init = 0;
    #75

    test = 0;
    x=6; y= 5; cin=0;
    #10 x=7'b1010101; y= 7'b0101010; cin=0;
    #10 cin = 1;
    #10 $finish;
    
    end
endmodule
