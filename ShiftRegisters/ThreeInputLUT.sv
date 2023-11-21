module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 
    reg[0:7] shift_out;
    
    always@(posedge clk) begin
        if(enable) begin
            shift_out <= {S, shift_out[0:6]};
        end
    end
    
    always@(*) begin
        Z = shift_out[{A,B,C}];
    end
    
endmodule