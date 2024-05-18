`timescale 1ns / 1ps

module csa_tb;
reg [6:0] x, y;
reg cin;
wire [6:0]sum;
wire cout;
csa csa1(x, y, cin, sum, cout);
initial
begin
x=6; y= 5; cin=0;
#5 x=20; y= 11; cin=0;
#5 $finish;

end
endmodule
