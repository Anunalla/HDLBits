module top_module(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q ); 
reg q_minus1, q_512;
    assign q_minus1 = 1'b0;
    assign q_512 = 1'b0;
    always @(posedge clk) begin
        if(load) begin 
            q <= data;
        end
        else begin
            q <= {q[510:0], q_minus1} ^ {q_512,q[511:1]};
        end
    end
endmodule