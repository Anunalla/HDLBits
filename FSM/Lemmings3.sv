module top_module(
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
    
    parameter[2:0] LEFT=0, RIGHT=1, FALL_L=2, DIG_L=3, FALL_R=4, DIG_R=5;
    reg[2:0] state, next_state;
    reg[3:0] in_concat;
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
                    (1'b0): next_state = FALL_L;
                    (1'b1): next_state = LEFT;
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
                    (1'b0): next_state = FALL_R;
                    (1'b1): next_state = RIGHT;
                endcase
            end
        endcase
    end
    
    always @(posedge clk, posedge areset) begin
        if(areset) begin
            state<=LEFT;
        end
        else begin
            state<=next_state;
        end
    end
    
    assign walk_left = (state==LEFT);
    assign walk_right = (state==RIGHT);
    assign digging = (state==DIG_L) | (state==DIG_R);
    assign aaah = (state==FALL_L) | (state==FALL_R);
endmodule
