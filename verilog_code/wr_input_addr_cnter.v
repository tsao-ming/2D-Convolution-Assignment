module wr_input_addr_cnter #(
    parameter WORDS_3X3_ADDR_DEPTH  = 9,
    parameter WORDS_5X5_ADDR_DEPTH  = 25,
    parameter IFMD_ADDR_DEPTH       = 64,   // 0~63
    parameter COUNT_WIDTH           = 6     // 0~24 or 0~8
)(
    input                           clk,
    input                           rst,
    input                           in_st,
    input                           is_5x5, // 1 for 5x5, 0 for 3x3
    input                           ifmd_wr_state,
    input                           kw_wr_state,
    output reg [COUNT_WIDTH-1:0]    count,     // 0~24 or 0~8
    output                          ifmd_wr_done,
    output                          kw_wr_done
);
    reg en_cnt;
    wire kw_wr_done =   kw_wr_state && 
                        ( (~is_5x5 && (count == WORDS_3X3_ADDR_DEPTH-1)) ||
                        ( is_5x5 && (count == WORDS_5X5_ADDR_DEPTH-1)) );

    wire ifmd_wr_done = ifmd_wr_state && (count == IFMD_ADDR_DEPTH-1);


    always @(posedge clk) begin
        if (!rst) begin
            count <= 0;
            en_cnt <= 1'b0;
        end
        else if (in_st) begin
            count <= 0;
            en_cnt <= 1'b1;
        end
        else if ( kw_wr_done || ifmd_wr_done ) begin
            count <= 0;
            en_cnt <= 1'b0;
        end
        else if (en_cnt) begin
            count <= count + 1'b1;
        end
    end

endmodule