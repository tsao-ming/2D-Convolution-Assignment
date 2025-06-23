module fsm (
    input clk,
    input rst,
    input in_st_ifmd,
    input [7:0] din,
    input ifmd_wr_done,
    input in_st_kw,
    input kw_is_5_5,
    input kw_wr_done,
    input calc_done,
    input ofmd_rd_done,


    output ifmd_ram1_en,
    output ifmd_wr1,
    output ifmd_ram2_en,
    output ifmd_wr2,
    output reg is_5x5,
    output kw_ram1_en,
    output kw_ram2_en,
    output kw_ram3_en,
    output kw_ram4_en,
    output kw_wr1,
    output kw_wr2,
    output kw_wr3,
    output kw_wr4,

    output rd_enable,
    output reg delay_calc_ing,
    output reg delay2_calc_ing,
    output reg delay3_calc_ing,
    output ofmd_wr_addr_en,
    output ofmd_rd_en,
    output ofmd_ram_en,
    output reg out_st,

    output ifmd_wr_state,
    output kw_wr_state
);

    // ====== State Definitions ======
    localparam
        IDLE            = 0,

        IFMD_WR1        = 1,
        IFMD_WAIT_WR2   = 2,
        IFMD_WR2        = 3,

        WAIT_KW_WR1     = 4,
        KW_WR1          = 5,
        WAIT_KW_WR2     = 6,
        KW_WR2          = 7,
        WAIT_KW_WR3     = 8,
        KW_WR3          = 9,
        WAIT_KW_WR4     = 10,
        KW_WR4          = 11,

        S_CALC          = 12,
        S_POST_CALC_1   = 13,
        S_POST_CALC_2   = 14,
        S_POST_CALC_3   = 15,
        S_READ_RESULT   = 16,
        
        DONE            = 17;

    // ====== State Registers ======
    reg [4:0] state, next_state;

    // ====== State Transition Logic ======
    always @(posedge clk) begin
        if (!rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ====== Next State Logic ======
    always @(*) begin
        case (state)
            IDLE: begin
                next_state = in_st_ifmd ? IFMD_WR1 : IDLE;
            end

            IFMD_WR1: begin
                next_state = ifmd_wr_done ? IFMD_WAIT_WR2 : IFMD_WR1;
            end

            IFMD_WAIT_WR2: begin
                next_state = in_st_ifmd ? IFMD_WR2 : IFMD_WAIT_WR2;
            end

            IFMD_WR2: begin
                next_state = ifmd_wr_done ? WAIT_KW_WR1 : IFMD_WR2;
            end

            WAIT_KW_WR1: begin
                next_state = in_st_kw ? KW_WR1 : WAIT_KW_WR1;
            end

            KW_WR1: begin
                next_state = kw_wr_done ? WAIT_KW_WR2 : KW_WR1;
            end

            WAIT_KW_WR2: begin
                next_state = in_st_kw ? KW_WR2 : WAIT_KW_WR2;
            end

            KW_WR2: begin
                next_state = kw_wr_done ? WAIT_KW_WR3 : KW_WR2;
            end

            WAIT_KW_WR3: begin
                next_state = in_st_kw ? KW_WR3 : WAIT_KW_WR3;
            end

            KW_WR3: begin
                next_state = kw_wr_done ? WAIT_KW_WR4 : KW_WR3;
            end

            WAIT_KW_WR4: begin
                next_state = in_st_kw ? KW_WR4 : WAIT_KW_WR4;
            end

            KW_WR4: begin
                next_state = kw_wr_done ? S_CALC : KW_WR4;
            end

            S_CALC: begin
                next_state = (calc_done) ? S_POST_CALC_1 : S_CALC; // 假設 kw_wr_done 代表計算完成
            end

            S_POST_CALC_1: begin
                next_state = S_POST_CALC_2;
            end

            S_POST_CALC_2: begin
                next_state = S_POST_CALC_3;
            end

            S_POST_CALC_3: begin
                next_state = S_READ_RESULT;
            end

            S_READ_RESULT: begin
                // next_state = S_READ_RESULT;
                next_state = (ofmd_rd_done) ? DONE : S_READ_RESULT;
            end

            DONE: begin
                next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // ====== Output Logic ======

    assign ifmd_ram1_en = (state == IFMD_WR1) || (state == S_CALC);
    assign ifmd_wr1     = (state == IFMD_WR1);
    assign ifmd_ram2_en = (state == IFMD_WR2) || (state == S_CALC);
    assign ifmd_wr2     = (state == IFMD_WR2);
    assign kw_ram1_en   = (state == KW_WR1) || (state == S_CALC);
    assign kw_ram2_en   = (state == KW_WR2) || (state == S_CALC);
    assign kw_ram3_en   = (state == KW_WR3) || (state == S_CALC);
    assign kw_ram4_en   = (state == KW_WR4) || (state == S_CALC);
    assign kw_wr1       = (state == KW_WR1);
    assign kw_wr2       = (state == KW_WR2);
    assign kw_wr3       = (state == KW_WR3);
    assign kw_wr4       = (state == KW_WR4);

    assign rd_enable   = (state == S_CALC) ;

    assign calc_ing = (state == S_CALC);

    assign ifmd_wr_state = (state == IFMD_WR1) || (state == IFMD_WR2);
    assign kw_wr_state = (state == KW_WR1) || (state == KW_WR2) || (state == KW_WR3) || (state == KW_WR4);

    always @(posedge clk) begin
        if (!rst)
            is_5x5 <= 1'b0;
        else if ( (state == WAIT_KW_WR1) && (~in_st_kw) )
            is_5x5 <= kw_is_5_5;
        else
            is_5x5 <= is_5x5;
    end

    always @(posedge clk) begin
        if (!rst) begin
            delay_calc_ing <= 1'b0;
            delay2_calc_ing <= 1'b0;
            delay3_calc_ing <= 1'b0;
        end
        else begin
            delay_calc_ing <= calc_ing;
            delay2_calc_ing <= delay_calc_ing;
            delay3_calc_ing <= delay2_calc_ing;
        end
    end

    assign ofmd_wr_addr_en = delay2_calc_ing ;
    assign ofmd_rd_en = (state == S_READ_RESULT);
    assign ofmd_ram_en = (state == S_READ_RESULT) || (state == S_CALC) || (state == S_POST_CALC_1) ||(state == S_POST_CALC_2) || (state == S_POST_CALC_3);

    always @(posedge clk) begin
        if (!rst)
            out_st <= 1'b0;
        else if (state == S_POST_CALC_3)
            out_st <= 1'b1;
        else
            out_st <= 1'b0;
    end
endmodule