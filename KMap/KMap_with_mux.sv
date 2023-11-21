module top_module (
    input c,
    input d,
    output [3:0] mux_in
); 
    // sop = (a'b'(c+d) + ab'd'+abcd)
    // assuming a b are used as selectors 4:1 mux, inputs to the 4:1 should be c,d combinations from each SOP term
    
    assign mux_in[0] = c|d;
    assign mux_in[1] = 1'b0;
    assign mux_in[2] = ~d;
    assign mux_in[3] = c&d;
    
    

endmodule