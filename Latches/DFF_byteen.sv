// Create 16 D flip-flops. It's sometimes useful to only modify parts of a group of flip-flops. The byte-enable inputs control whether each byte of the 16 registers should be written to on that cycle. byteena[1] controls the upper byte d[15:8], while byteena[0] controls the lower byte d[7:0].

// resetn is a synchronous, active-low reset.

// All DFFs should be triggered by the positive edge of clk.
module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);
    int i;
    always @ (posedge clk) begin
        if(resetn==0) begin
            q<= '0;
        end
        else begin
            //q[byteena*4 +:4] <= d[byteena*4 +:4];
            for (i=0; i<2; i++) begin
                if(byteena[i]==1'b1) begin
                    q[i*8 +:8]<=d[i*8 +:8];
                end
            end
        end
    end

endmodule