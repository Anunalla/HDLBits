module top_module (
    input clk,
    input x,
    output z
); 

    reg [2:0] q, qbar, d;
    assign qbar = ~ q;
    assign z = ~ (|(q[2:0]));
    assign d[0] = x ^ q[0];
    assign d[1] = x & qbar[1];
    assign d[2] = x | qbar[2];
    
    initial begin 
        q<='0;
    end
    always @(posedge clk) begin
        q<=d;
    end
endmodule