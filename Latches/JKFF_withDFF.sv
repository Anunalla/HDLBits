module top_module (
    input clk,
    input j,
    input k,
    output Q);
    
    reg D;
    assign D = j& (~Q) | ((~k) & Q); 
    
    always @(posedge clk) begin
        Q <=D;
    end

endmodule