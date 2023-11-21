module top_module (
    input d, 
    input ena,
    output q);
    always @(ena) begin
        if(ena==1) q<=d;
    end
endmodule