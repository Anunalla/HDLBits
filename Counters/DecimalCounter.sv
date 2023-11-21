// Build a 4-digit BCD (binary-coded decimal) counter. 
// Each decimal digit is encoded using 4 bits: q[3:0] is the ones digit, q[7:4] is the tens digit, etc. 
//     For digits [3:1], also output an enable signal indicating 
//     when each of the upper three digits should be incremented.
//     You may want to instantiate or modify some one-digit decade counters.
module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    wire [3:0] ena_temp;
    genvar i,j;
    generate
        for(i=0; i<4; i++) begin : enableGen
            assign ena_temp[i] = (q[(i)*4 +:4]==4'd9);
    end
    endgenerate
    
    assign ena = {(q[3:0]==9 && q[7:4]==9 && q[11:8]==9),q[3:0]==9 && q[7:4]==9,q[3:0]==9} ;
    
    counterBCD cOnes (clk,reset,1,q[3:0]);
    counterBCD cTens (clk,reset,ena_temp[0],q[7:4]);
    counterBCD cHundreds (clk,reset,ena_temp[0] && ena_temp[1],q[11:8]);
    counterBCD cThousands (clk,reset,ena_temp[0] && ena_temp[1] && ena_temp[2] ,q[15:12]);

endmodule

module counterBCD (input clk, input reset, input ena, output[3:0] q);
    always @(posedge clk) begin
        if(reset) begin
            q <= 4'd0;
        end
        else begin 
            if (ena) begin
            if(q == 4'd9) begin
                q<= 4'd0;
            end
            else begin
                q <= q+4'd1;
        end
            end
    end
    end
endmodule