module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 
	
    reg[63:0] q_right1;
    reg[63:0] q_right8;
    reg[63:0] q_left1;
    reg[63:0] q_left8;
    
    always @(q) begin
        q_left1 = {q[62:0],1'b0};
        q_right1 = {q[63], q[63:1]};
        q_left8 = {{8{1'b0}},{q[55:0]}};
        q_right8 = {{8{q[63]}},{q[63:8]}} ;
    end
    
    always @(posedge clk) begin
            if(load)
            	q <= data;
        else begin
            if(ena) begin
                case(amount)
                    2'b00: q <= q_left1;
                    2'b10: q <= q_right1;
                    2'b01: q <= q_left8;
                    2'b11: q <= q_right8;
                    default: q <= q;
                endcase
                end
            end
        end
    
endmodule

`timescale 1ps/1ps
module tb();

bit clk, load, ena;
bit[1:0] amount;
reg[63:0] data;
reg[63:0] q;
top_module dut (clk,load,ena,amount,data,q);
always #1 clk = ~clk;
initial begin
    #1 load = 1'b1; data = 100; ena= 1'b0; amount = 2'b0;
    #2 load = 1'b0; ena=1'b1; amount = 2'd2;
    #8 amount =  2'd1;
    #12 $finish();
end
endmodule