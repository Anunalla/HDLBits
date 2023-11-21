module top_module (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    reg[7:0] in_ff, anyedge_temp;
    assign anyedge_temp = in ^ in_ff;
    always @(posedge clk) begin
        in_ff <= in;
        anyedge <=anyedge_temp;
    end
endmodule