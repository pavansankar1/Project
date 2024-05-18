`timescale 1ns / 1ps

module rca_tb;
reg [3:0]a, b;
reg cin;

wire [3:0] sum;
wire cout;

rca rt(a, b, cin, sum, cout);
initial
begin
    a = 4'b1010; b = 4'b0101; cin = 0;
    #10 cin = 1;
    #10 $finish;
end

endmodule