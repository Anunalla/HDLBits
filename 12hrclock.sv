module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss); 
    
    assign pm = (ss==8'd59 && mm==8'd59 && hh==8'd12);
    counterBCD seconds(clk, reset, ena, 8'd59, 8'd0, ss);
    counterBCD minutes(clk, reset, (ena && ss == 8'd59), 8'd59, 8'd0, mm);
    counterBCD hours(clk, reset, (ena && ss==8'd59 && mm==8'd59), 8'd12,8'd12, hh);

endmodule


module counterBCD (input clk, input reset, input ena, input [7:0] q_lim, input [7:0]  q_start, output[7:0] q);
    function [7:0] out (input [7:0] in);
        begin
            out[3:0] = in % 10;
            out[7:4] = (in / 10) % 10;
        end
    endfunction
    reg [7:0] q_temp;
    assign q = out(q_temp);
    always @(posedge clk) begin
        if(reset) begin
            q_temp <= q_start;
        end
        else begin 
            if (ena) begin
                if(q_temp == q_lim) begin
                	q_temp <= 7'd0;
            	end
            	else begin
                	q_temp <= q_temp + 7'd1;
        		end
            end
    	end
    end
endmodule

`timescale 1ps/1ps
module tb();
    bit clk;
    bit ena=1;
    bit reset=1;
    wire pm;
    wire [7:0] hh;
    wire [7:0] mm;
    wire [7:0] ss;

top_module dut (
        // Inputs:
    .clk    (clk),
    .ena    (ena),
    .reset  (reset),
        // Outputs:
    .hh     (hh),
    .mm     (mm),
    .pm     (pm),
    .ss     (ss)
);

always #1 clk++;

initial begin
    #2 reset=0;
    #200 $stop();
end
endmodule