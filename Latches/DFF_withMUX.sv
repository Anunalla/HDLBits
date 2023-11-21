module top_module (
	input clk,
	input L,
	input r_in,
	input q_in,
	output reg Q);
    
    reg mux_out_d;
    assign mux_out_d = L ? r_in : q_in;
    always @(posedge clk) begin
        Q<=mux_out_d;
    end

endmodule