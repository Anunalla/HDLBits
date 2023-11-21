module top_module (
    input clk,
    input w, R, E, L,
    output Q
);
 reg mux1_out, mux2_outD;
    assign mux1_out = E ? w :Q;
    assign mux2_outD = L ? R: mux1_out;
    always @(posedge clk) begin
        Q<=mux2_outD;
    end
endmodule