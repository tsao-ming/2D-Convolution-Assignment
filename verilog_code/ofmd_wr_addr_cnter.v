module ofmd_wr_addr_cnter #(
    parameter ADDR_WIDTH = 6 // 2^6 = 64
) (
    input clk,
    input rst,
    input en,
    input delay2_every,

    output reg [ADDR_WIDTH-1:0] addr_cnt // 0~15
);
    reg [5:0] addr_cnt_prev;
    always @(posedge clk) begin
        if (!rst) begin
            addr_cnt_prev <= 0;
            addr_cnt <= 0;
        end
        else if (en) begin
            // If delay2_every is high, increment the address counter
            if (delay2_every) begin
                addr_cnt_prev <= addr_cnt_prev + 1'b1;
                addr_cnt <= addr_cnt_prev;
            end
        end
    end
endmodule