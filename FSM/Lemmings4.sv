module lemmings4(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    parameter[2:0] LEFT=0, RIGHT=1, FALL_L=2, DIG_L=3, FALL_R=4, DIG_R=5, DEAD=6;
    reg[2:0] state, next_state;
    reg[3:0] in_concat;
    reg[5:0] fall_counter;
    
    assign in_concat = {ground,dig,bump_right,bump_left};
    always@(*) begin
        case(state)
            (LEFT): begin
                casex(in_concat)
                    (4'b10x1): next_state = RIGHT;
                    (4'b0xxx): next_state = FALL_L;
                    (4'b11xx): next_state = DIG_L;
                    (4'b10x0): next_state = LEFT;
                endcase
            end
            (RIGHT): begin
                casex(in_concat)
                    (4'b101x): next_state = LEFT;
                    (4'b0xxx): next_state = FALL_R;
                    (4'b11xx): next_state = DIG_R;
                    (4'b100x): next_state = RIGHT;
                endcase
            end
            
            (DIG_L): begin
                case(ground) 
                    (1'b1): next_state = DIG_L;
                    (1'b0): next_state = FALL_L;
                endcase
            end
            (FALL_L): begin
                case(ground)
                    (1'b0): begin
                       	next_state = FALL_L;
                        end
                    (1'b1): begin 
                        if(fall_counter>= 5'd20) 
                            next_state = DEAD; 
                        else next_state = LEFT; 
                    end
                endcase
            end
            (DIG_R): begin
                case(ground) 
                    (1'b1): next_state = DIG_R;
                    (1'b0): next_state = FALL_R;
                endcase
            end
            (FALL_R): begin
                case(ground)
                    (1'b0): begin
                       	next_state = FALL_R;
                        end
                    (1'b1): begin 
                        if(fall_counter>= 5'd20) 
                            next_state = DEAD; 
                        else next_state = RIGHT; 
                    end
                endcase
            end
            (DEAD): begin
                next_state = DEAD;
            end
        endcase
    end
    
    always @(posedge clk, posedge areset) begin
        if(areset) begin
            state<=LEFT;
            fall_counter<=5'd0;
        end
        else begin
            if((state == FALL_L) | (state==FALL_R)) begin
                if(fall_counter<5'd31) begin // avoid counter overflow
                    fall_counter <= (fall_counter+5'd1);
                end
                state <= next_state;
            end
            else begin 
                    fall_counter <= 5'd0;
                    state<=next_state; 
            end
        end
    end
    
    assign walk_left = (state==LEFT) & (state!=DEAD);
    assign walk_right = (state==RIGHT)& (state!=DEAD);
    assign digging = ((state==DIG_L) | (state==DIG_R)) & (state!=DEAD);
    assign aaah = ((state==FALL_L) | (state==FALL_R)) & (state!=DEAD);
endmodule


`timescale 1ps/1ps
module tb_lemmings4();
    bit clk;
    reg areset, bump_left, bump_right, ground, dig, walk_left, walk_right, aaah, digging;
    lemmings4 dut(clk, areset,bump_left,bump_right,ground,dig, walk_left,walk_right,aaah, digging);

    always #1 clk++;

    initial begin
        @(negedge clk);
        areset = 1'b0; bump_left = 1'b0; bump_right = 1'b0; ground = 1'b1; dig=1'b0;
        @(posedge clk);
        areset = 1'b1;
        @(posedge clk);
        areset = 1'b0;
        @(posedge clk);
        @(posedge clk);
        ground=1'b0;
        repeat(25) @(posedge clk);
        #5 $stop();
    end
endmodule