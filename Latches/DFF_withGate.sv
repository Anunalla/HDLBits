module top_module (
    input clk,
    input in, 
    output out);
reg d;
    assign d = in ^out;
    always @(posedge clk) begin
        out<=d;
    end
endmodule