module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
	
    parameter[1:0] LEFT=0, RIGHT=1, FALL=2;
    reg[1:0] state, next_state, last_walkdir;

    always @(*) begin
        // State transition logic
        case(state)
            FALL: begin
                if(ground==1) next_state = last_walkdir;
                else next_state = FALL;
            end
            LEFT: begin
                if(ground==0) begin next_state = FALL; last_walkdir = LEFT; end 
                else if(bump_left) next_state = RIGHT;
                else next_state = LEFT;
            end
            RIGHT: begin
                if(ground==0) begin next_state = FALL; last_walkdir = RIGHT; end 
                else if(bump_right) next_state = LEFT;
                else next_state = RIGHT;
            end
            default: begin next_state = LEFT; last_walkdir = LEFT; end
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset) begin
            state <= LEFT;
        end
        else begin
            //if(ground==0) begin
                //if(state!=FALL) last_walkdir <= state;
               // state <= FALL;
           // end
            //else 
                state <= next_state;
        end
        // State flip-flops with asynchronous reset
    end

    // Output logic
    assign walk_left = (state == LEFT) ? 1'b1 : 1'b0;
    assign walk_right = (state == RIGHT) ? 1'b1 : 1'b0;
    assign aaah = (state == FALL) ? 1'b1 : 1'b0;

endmodule

`timescale 1ps/1ps
module tb_lem2 ();
    bit clk;
    reg areset, bump_left, bump_right, ground, walk_left, walk_right, aaah;
    top_module dut(clk, areset,bump_left,bump_right,ground,walk_left,walk_right,aaah);

    always #1 clk++;

    initial begin
        #1 areset = 1'b0; bump_left = 1'b0; bump_right = 1'b0; ground = 1'b1;
        #10 ground=1'b0;
        #14 ground=1'b1; bump_left = 1'b1;
        #18 ground=1'b0; bump_left = 1'b0;
        #22 ground=1'b1;
        #25 $stop();
    end
endmodule