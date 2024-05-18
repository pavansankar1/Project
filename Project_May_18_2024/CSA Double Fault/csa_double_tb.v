`timescale 1ns / 1ps

module csa_double_tb;

reg [6:0] x, y;
reg cin, test;
wire [6:0]sum;
wire cout;
wire [29:0]actual_output;

reg clk, init;
wire [5:0]desired_output;
wire [3:0]test_data;

wire [4:0]comp;
wire [2:0]is0, is1;
wire [3:0]ss0, ss1;
//csa_double csad(is0, is1, ss0, ss1, x, y, cin, test, test_data, sum, cout, actual_output);
csa_double_faulty csadf(is0, is1, ss0, ss1, x, y, cin, test, test_data, sum, cout, actual_output);
csa_double_tpg cdt(clk, init, test, test_data, desired_output);
csa_double_mul_sel_gen2 cdmsg2(clk, init, test, actual_output, desired_output, is0, is1, ss0, ss1, comp);

always #5 clk = ~clk;
initial
    begin
    test = 1;
    clk = 0;
    init = 1;
    #2 init = 0;
    #75
    
    //is0=3'b111; is1=3'b111; ss0=4'b1111; ss1=4'b1111;
    test = 0;
    x=6; y= 5; cin=0;
    #10 x=7'b1010101; y= 7'b0101010; cin=0;
    #10 cin = 1;
    #10 $finish;
    end
endmodule
