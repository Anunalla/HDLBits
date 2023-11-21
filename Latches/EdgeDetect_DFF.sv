module top_module (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);
    reg [7:0] in_ff, pedge_temp;
    always @(posedge clk) begin
        in_ff <= in;
        pedge <= pedge_temp;
    end
    assign pedge_temp = ~(in_ff) &in;
    
    
endmodule