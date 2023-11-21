module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    reg[31:0] in_ff, out_old;
    reg reset_temp;
    assign out_old = out;
    //assign out_temp
    always @(posedge clk) begin
        if(reset ==1'b1) begin
            out='0;
            in_ff = in;
        end
        else begin
            in_ff <=  in;
            out <= (out | (~in & in_ff));
            reset_temp <= reset;
        end
    end
endmodule