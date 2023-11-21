module top_module (
    input clk,
    input d,
    output q
);
    reg q_p, q_n; 
    assign q = clk ? q_p : q_n;
    always @(posedge clk) begin
        q_p<=d;
    end
    always @(negedge clk) begin
        q_n<=d;
    end

endmodule