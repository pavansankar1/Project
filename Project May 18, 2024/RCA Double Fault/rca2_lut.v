`timescale 1ns / 1ps

module rca2_lut( count, adder_sums, adder_carrys, comp);
input [3:0]adder_sums;
input [3:0]adder_carrys;
input[2:0]count;
output wire [7:0]comp;
reg[3:0]org_values;
wire [7:0]org_output;
wire [0:7]s0 = 8'b11100001;
wire [0:7]s1 = 8'b01110001;
wire [0:7]c0 = 8'b00010111;
wire [0:7]c1 = 8'b10000111;
assign org_output = {org_values[3], org_values[2], org_values[3], org_values[2], org_values[1], org_values[0], org_values[1], org_values[0]};
assign comp = org_output ^ {adder_carrys, adder_sums};
always @(count)
    begin
    case(count)
        3'd0 : org_values = {c1[0], c0[0], s1[0], s0[0]};
        3'd1 : org_values = {c1[1], c0[1], s1[1], s0[1]};
        3'd2 : org_values = {c1[2], c0[2], s1[2], s0[2]};
        3'd3 : org_values = {c1[3], c0[3], s1[3], s0[3]};
        3'd4 : org_values = {c1[4], c0[4], s1[4], s0[4]};
        3'd5 : org_values = {c1[5], c0[5], s1[5], s0[5]};
        3'd6 : org_values = {c1[6], c0[6], s1[6], s0[6]};
        3'd7 : org_values = {c1[7], c0[7], s1[7], s0[7]};
        default: org_values = 0;
    endcase
    end
    
endmodule
