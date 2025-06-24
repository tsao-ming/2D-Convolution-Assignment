module ifmd_rd_addr_gener #(
    parameter IFMD_H       = 8,       // Height of the IFMD
    parameter IFMD_W       = 8,       // Width of the IFMD
    parameter KW_H_3       = 3,       // Height of the kernel window
    parameter KW_W_3       = 3,        // Width of the kernel window
    parameter KW_H_5       = 5,       // Height of the kernel window for 5x5
    parameter KW_W_5       = 5        // Width of the kernel window for
)(
    input               clk,
    input               rst,
    input               enable,
    input               is_5x5, // 1 for 5x5 kernel, 0 for 3x3 kernel

    output reg [5:0]    ifmd_rd_addr,   // 0~63
    output reg [4:0]    cnt_b, // 0~8
    output reg          delay2_b,
    output              ifmd_rd_done         // 324
);
    localparam OFMD_H_3 = IFMD_H - KW_H_3 + 1;
    localparam OFMD_W_3 = IFMD_W - KW_W_3 + 1;
    localparam OFMD_H_5 = IFMD_H - KW_H_5 + 1;
    localparam OFMD_W_5 = IFMD_W - KW_W_5 + 1;

    localparam TOTAL_COUNT_3x3 = (OFMD_H_3 * OFMD_W_3 * KW_H_3 * KW_W_3);
    localparam TOTAL_COUNT_5x5 = (OFMD_H_5 * OFMD_W_5 * KW_H_5 * KW_W_5);

    reg  [8:0] count; // 0~323
    wire [8:0] TOTAL_COUNT;
    assign TOTAL_COUNT = is_5x5 ? TOTAL_COUNT_5x5 : TOTAL_COUNT_3x3; // 324 for 3x3, 400 for 5x5

    reg  [2:0] cnt_a;
    wire [2:0] cnt_a_max;
    assign cnt_a_max = is_5x5 ? (KW_W_5 - 1) : (KW_W_3 - 1);

    wire [4:0] cnt_b_max;
    assign cnt_b_max = is_5x5 ? (KW_H_5 * KW_W_5 - 1) : (KW_H_3 * KW_W_3 - 1);

    reg [6:0] cnt_c;
    wire [6:0] cnt_c_max;
    assign cnt_c_max = is_5x5 ? (KW_H_5 * KW_W_5 * OFMD_W_5 - 1) : (KW_H_3 * KW_W_3 * OFMD_W_3 - 1);


    wire signed [5:0] pulse_a_offset;
    assign pulse_a_offset = is_5x5 ? (IFMD_W - KW_W_5 + 1) : (IFMD_W - KW_W_3 + 1);             // +4 for 5x5, +6 for 3x3

    wire signed [5:0] pulse_b_offset;
    assign pulse_b_offset = is_5x5 ?    -(KW_H_5 - 1) * IFMD_W - (KW_W_5 - 1) + 1 : 
                                        -(KW_H_3 - 1) * IFMD_W - (KW_W_3 - 1) + 1;              // -35 for 5x5, -17 for 3x3

    wire signed [5:0] pulse_c_offset;
    assign pulse_c_offset = is_5x5 ? -(KW_H_5 - 1) * IFMD_W + 1 : -(KW_H_3 - 1) * IFMD_W + 1;   // -31 for 5x5, -15 for 3x3


    always @(posedge clk) begin
        if (!rst) begin
            count <= 0;
        end
        else if (enable) begin
            if (count == TOTAL_COUNT) begin
                count <= 0; // reset to 0 after reaching 323
            end
            else begin
                count <= count + 1;
            end
        end
    end
    assign ifmd_rd_done = (count == TOTAL_COUNT); // 324

    always @(posedge clk) begin
        if (!rst) begin                 // 歸零
            cnt_a <= 0;
        end else if (enable) begin          // enable on
            if (cnt_a == cnt_a_max)
                cnt_a <= 0;
            else
                cnt_a <= cnt_a + 1'b1;        
        end else begin                      // enable off
            cnt_a <= 0;
        end
    end
    wire pulse_a = (cnt_a == cnt_a_max);

    always @(posedge clk) begin
        if (!rst) begin                 // 歸零
            cnt_b <= 0;
        end else if (enable) begin          // enable on
            if (cnt_b == cnt_b_max)
                cnt_b <= 0;
            else
                cnt_b <= cnt_b + 1'b1;        
        end else begin                      // enable off
            cnt_b <= 0;
        end
    end
    wire pulse_b = (cnt_b == cnt_b_max);

    always @(posedge clk) begin
        if (!rst) begin                 // 歸零
            cnt_c <= 0;
        end else if (enable) begin          // enable on
            if (cnt_c == cnt_c_max)
                cnt_c <= 0;
            else
                cnt_c <= cnt_c + 1'b1;        
        end else begin                      // enable off
            cnt_c <= 0;
        end
    end
    wire pulse_c = (cnt_c == cnt_c_max);

    always @(posedge clk) begin
        if (!rst)
            ifmd_rd_addr <= 0;
        else if (ifmd_rd_done) // 324
            ifmd_rd_addr <= 0;
        else if (pulse_c) // 54
            ifmd_rd_addr <= ifmd_rd_addr + pulse_c_offset;      // -31 for 5x5, -15 for 3x3
        else if (pulse_b) // 9
            ifmd_rd_addr <= ifmd_rd_addr + pulse_b_offset;      // -35 for 5x5, -17 for 3x3
        else if (pulse_a) // 3
            ifmd_rd_addr <= ifmd_rd_addr + pulse_a_offset;      // +4 for 5x5, +6 for 3x3
        else if (enable)
            ifmd_rd_addr <= ifmd_rd_addr + 1'b1;
    end

    
    reg delay_b;
    always @(posedge clk) begin
        if (!rst) begin
            delay_b <= 1'b0;
            delay2_b <= 1'b0;
        end
        else begin
            delay_b <= pulse_b;
            delay2_b <= delay_b;
        end
    end

endmodule