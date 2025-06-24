module top #(
    parameter IFMD_H            = 8,         // Height of IFMD
    parameter IFMD_W            = 8,         // Width of IFMD
    parameter KW_H_3            = 3,         // Height of 3x3 kernel
    parameter KW_W_3            = 3,         // Width of 3x3 kernel
    parameter KW_H_5            = 5,        
    parameter KW_W_5            = 5,
    parameter INPUT_DATA_WIDTH  = 8,         // Data width for IFMD and KW
    parameter OUTPUT_DATA_WIDTH = 16         // Data width for OFMD
)(
    input                           clk,
    input                           rst,
    input   [INPUT_DATA_WIDTH-1:0]  din,
    input                           in_st_ifmd,
    input                           in_st_kw,
    input                           kw_is_5_5,

    output                          out_st,
    output  [OUTPUT_DATA_WIDTH-1:0] dout_ofmd1,
    output  [OUTPUT_DATA_WIDTH-1:0] dout_ofmd2
);

localparam IFMD_ADDR_DEPTH      = IFMD_H * IFMD_W;       // 8x8 IFMD has 64 words
localparam WORDS_3X3_ADDR_DEPTH = KW_H_3 * KW_W_3;
localparam WORDS_5X5_ADDR_DEPTH = KW_H_5 * KW_W_5;
localparam OFMD_H_3 = IFMD_H - KW_H_3 + 1;              // Height of OFMD for 3x3 kernel
localparam OFMD_W_3 = IFMD_W - KW_W_3 + 1;
localparam OFMD_H_5 = IFMD_H - KW_H_5 + 1;
localparam OFMD_W_5 = IFMD_W - KW_W_5 + 1;
localparam OFMD_ADDR_DEPTH_3 = OFMD_H_3 * OFMD_W_3;    // 6x6 OFMD has 36 words
localparam OFMD_ADDR_DEPTH_5 = OFMD_H_5 * OFMD_W_5;    // 4x4 OFMD has 16 words

wire [7:0] ifmd1_dout, ifmd2_dout;
wire ifmd_wr_done;
wire kw_wr_done;
wire is_5x5;


wire [5:0] ifmd_wr_addr;

wire ifmd_ram1_en;
wire ifmd_wr1;
wire ifmd_ram2_en;
wire ifmd_wr2;

wire [4:0] kw_wr_addr;

wire [5:0] ifmd_rd_addr;
wire ifmd_rd_done;

wire [4:0] kw_rd_addr;
wire [7:0] kw1_dout, kw2_dout, kw3_dout, kw4_dout;
wire [19:0] mult_out_1, mult_out_2, mult_out_3, mult_out_4;

wire [19:0] acc_out_1, acc_out_2, acc_out_3, acc_out_4;
wire [5:0]  ofmd_wr_addr;
wire [20:0] add_data1_21bits, add_data2_21bits;
wire [19:0] accu_we_need_data1, accu_we_need_data2, accu_we_need_data3, accu_we_need_data4;
wire [15:0] dout_ofmd1, dout_ofmd2;

wire [5:0]  ofmd_rd_addr;

wire [5:0] wr_addr;

// FSM module
fsm fsm (
    .clk(clk),
    .rst(rst),
    .in_st_ifmd(in_st_ifmd),
    .ifmd_wr_done(ifmd_wr_done),
    .in_st_kw(in_st_kw),
    .kw_is_5_5(kw_is_5_5),
    .kw_wr_done(kw_wr_done),
    .calc_done(ifmd_rd_done),
    .ofmd_rd_done(ofmd_rd_done),

    .ifmd_ram1_en(ifmd_ram1_en),
    .ifmd_wr1(ifmd_wr1),
    .ifmd_ram2_en(ifmd_ram2_en),
    .ifmd_wr2(ifmd_wr2),
    .is_5x5(is_5x5),
    .kw_ram1_en(kw_ram1_en),
    .kw_ram2_en(kw_ram2_en),
    .kw_ram3_en(kw_ram3_en),
    .kw_ram4_en(kw_ram4_en),
    .kw_wr1(kw_wr1),
    .kw_wr2(kw_wr2),
    .kw_wr3(kw_wr3),
    .kw_wr4(kw_wr4),
    
    .rd_enable(rd_enable),
    .delay_calc_ing(delay_calc_ing),
    .delay2_calc_ing(delay2_calc_ing),
    .delay3_calc_ing(delay3_calc_ing),
    .ofmd_wr_addr_en(ofmd_wr_addr_en),
    .ofmd_rd_en(ofmd_rd_en),
    .ofmd_ram_en(ofmd_ram_en),
    .out_st(out_st),
    .ifmd_wr_state(ifmd_wr_state),
    .kw_wr_state(kw_wr_state)
);

wr_input_addr_cnter #(
    .WORDS_3X3_ADDR_DEPTH(WORDS_3X3_ADDR_DEPTH),  // 3x3 kernel has 9 words
    .WORDS_5X5_ADDR_DEPTH(WORDS_5X5_ADDR_DEPTH), // 5x5 kernel has 25 words
    .IFMD_ADDR_DEPTH(IFMD_ADDR_DEPTH),          // IFMD has 64 words
    .COUNT_WIDTH(6)                             // Count width for IFMD and KW
) wr_input_addr_cnter (
    .clk(clk),
    .rst(rst),
    .in_st(in_st_ifmd || in_st_kw),
    .is_5x5(is_5x5),
    .ifmd_wr_state(ifmd_wr_state),
    .kw_wr_state(kw_wr_state),

    .count(wr_addr),
    .ifmd_wr_done(ifmd_wr_done),
    .kw_wr_done(kw_wr_done)
);


// ------------IFMD RAMs------------
    ram #(
        .DATA_WIDTH(INPUT_DATA_WIDTH),
        .WORDS(IFMD_ADDR_DEPTH), // 64 words for 8x8 IFMD
        .ADDR_WIDTH(6)
    ) ram_ifmd1 (
        .clk(clk),
        .en(ifmd_ram1_en),
        .wr(ifmd_wr1),
        .address_wr(wr_addr),
        .address_rd(ifmd_rd_addr),
        .din(din),
        .dout(ifmd1_dout)
    );
    ram #(
        .DATA_WIDTH(INPUT_DATA_WIDTH),
        .WORDS(IFMD_ADDR_DEPTH),
        .ADDR_WIDTH(6)
    ) ram_ifmd2 (
        .clk(clk),
        .en(ifmd_ram2_en),
        .wr(ifmd_wr2),
        .address_wr(wr_addr),
        .address_rd(ifmd_rd_addr),
        .din(din),
        .dout(ifmd2_dout)
    );
// ---------------------------------

// -------------KW RAMs-------------
    ram #(
        .DATA_WIDTH(INPUT_DATA_WIDTH),
        .WORDS(WORDS_5X5_ADDR_DEPTH), // 25 words for 5x5 kernel
        .ADDR_WIDTH(5)      // 2^5
    ) ram_kw1 (
        .clk(clk),
        .en(kw_ram1_en),
        .wr(kw_wr1),
        .address_wr(wr_addr[4:0]),
        .address_rd(kw_rd_addr),
        .din(din),
        .dout(kw1_dout)
    );
    ram #(
        .DATA_WIDTH(INPUT_DATA_WIDTH),
        .WORDS(WORDS_5X5_ADDR_DEPTH),
        .ADDR_WIDTH(5)      // 2^5
    ) ram_kw2 (
        .clk(clk),
        .en(kw_ram2_en),
        .wr(kw_wr2),
        .address_wr(wr_addr[4:0]),
        .address_rd(kw_rd_addr),
        .din(din),
        .dout(kw2_dout)
    );
    ram #(
        .DATA_WIDTH(INPUT_DATA_WIDTH),
        .WORDS(WORDS_5X5_ADDR_DEPTH),
        .ADDR_WIDTH(5)      // 2^5
    ) ram_kw3 (
        .clk(clk),
        .en(kw_ram3_en),
        .wr(kw_wr3),
        .address_wr(wr_addr[4:0]),
        .address_rd(kw_rd_addr),
        .din(din),
        .dout(kw3_dout)
    );
    ram #(
        .DATA_WIDTH(INPUT_DATA_WIDTH),
        .WORDS(WORDS_5X5_ADDR_DEPTH),
        .ADDR_WIDTH(5)      // 2^5
    ) ram_kw4 (
        .clk(clk),
        .en(kw_ram4_en),
        .wr(kw_wr4),
        .address_wr(wr_addr[4:0]),
        .address_rd(kw_rd_addr),
        .din(din),
        .dout(kw4_dout)
    );
// ---------------------------------

ifmd_rd_addr_gener #(
    .IFMD_H(IFMD_H),         // Height of IFMD
    .IFMD_W(IFMD_W),         // Width of IFMD
    .KW_H_3(KW_H_3),         // Height of 3x3 kernel
    .KW_W_3(KW_W_3),         // Width of 3x3 kernel
    .KW_H_5(KW_H_5),         // Height of 5x5 kernel
    .KW_W_5(KW_W_5)          // Width of 5x5 kernel
) ifmd_rd_addr_gener (
    .clk(clk),
    .rst(rst),
    .enable(rd_enable),
    .is_5x5(is_5x5),

    .ifmd_rd_addr(ifmd_rd_addr),
    .cnt_b(kw_rd_addr), // 0~24 or 0~8
    .delay2_b(delay2_every),
    .ifmd_rd_done(ifmd_rd_done)
);

// Multiplication and accumulation ------------------------
    multer8x8_signed multer_1 (
        .a(ifmd1_dout),
        .b(kw1_dout),
        .out(mult_out_1)
    );
    multer8x8_signed multer_2 (
        .a(ifmd2_dout),
        .b(kw2_dout),
        .out(mult_out_2)
    );
    multer8x8_signed multer_3 (
        .a(ifmd1_dout),
        .b(kw3_dout),
        .out(mult_out_3)
    );
    multer8x8_signed multer_4 (
        .a(ifmd2_dout),
        .b(kw4_dout),
        .out(mult_out_4)
    );
    accumulator acc_1 (
        .clk(clk),
        .rst(rst),
        .en(delay_calc_ing),
        .data_in(mult_out_1),
        .load_new_value(delay2_every), 

        .acc_out(acc_out_1) // 0~35
    );
    accumulator acc_2 (
        .clk(clk),
        .rst(rst),
        .en(delay_calc_ing),
        .data_in(mult_out_2),
        .load_new_value(delay2_every),

        .acc_out(acc_out_2)
    );
    accumulator acc_3 (
        .clk(clk),
        .rst(rst),
        .en(delay_calc_ing),
        .data_in(mult_out_3),
        .load_new_value(delay2_every),

        .acc_out(acc_out_3)
    );
    accumulator acc_4 (
        .clk(clk),
        .rst(rst),
        .en(delay_calc_ing),
        .data_in(mult_out_4),
        .load_new_value(delay2_every),

        .acc_out(acc_out_4)
    );

    accu_result_reg accu_result_reg1 (
        .clk(clk),
        .rst(rst),
        .acc_out(acc_out_1),
        .load_new_value(delay2_every),

        .data(accu_we_need_data1)
    );
    accu_result_reg accu_result_reg2 (
        .clk(clk),
        .rst(rst),
        .acc_out(acc_out_2),
        .load_new_value(delay2_every),

        .data(accu_we_need_data2)
    );
    accu_result_reg accu_result_reg3 (
        .clk(clk),
        .rst(rst),
        .acc_out(acc_out_3),
        .load_new_value(delay2_every),

        .data(accu_we_need_data3)
    );
    accu_result_reg accu_result_reg4 (
        .clk(clk),
        .rst(rst),
        .acc_out(acc_out_4),
        .load_new_value(delay2_every),

        .data(accu_we_need_data4)
    );
    adder_21bits adder_1 (
        .a({accu_we_need_data1[19], accu_we_need_data1}),
        .b({accu_we_need_data2[19], accu_we_need_data2}),
        .out(add_data1_21bits) // 0~35
    );
    adder_21bits adder_2 (
        .a({accu_we_need_data3[19], accu_we_need_data3}),
        .b({accu_we_need_data4[19], accu_we_need_data4}),
        .out(add_data2_21bits) // 0~35
    );
// -----------------------------------------------------------
    
// OFMD write address generator
ofmd_wr_addr_cnter #(
    .ADDR_WIDTH(6) // 2^6 = 64
) ofmd_wr_addr_cnter (
    .clk(clk),
    .rst(rst),
    .en(ofmd_wr_addr_en),
    .delay2_every(delay2_every),
    .addr_cnt(ofmd_wr_addr) // 0~35 or 0~15
);

// ------------OFMD RAMs------------
    ram #(
        .DATA_WIDTH(OUTPUT_DATA_WIDTH),
        .WORDS(OFMD_ADDR_DEPTH_3), // 36 words for 6x6 OFMD
        .ADDR_WIDTH(6)
    ) ram_ofmd1 (
        .clk(clk),
        .en(ofmd_ram_en),
        .wr(delay3_calc_ing),
        .address_wr(ofmd_wr_addr),
        .address_rd(ofmd_rd_addr),
        .din(add_data1_21bits[20:5]), // 16 bits
        .dout(dout_ofmd1)
    );
    ram #(
        .DATA_WIDTH(OUTPUT_DATA_WIDTH),
        .WORDS(OFMD_ADDR_DEPTH_3),  // 36 words for 6x6 OFMD
        .ADDR_WIDTH(6)
    ) ram_ofmd2 (
        .clk(clk),
        .en(ofmd_ram_en),
        .wr(delay3_calc_ing),
        .address_wr(ofmd_wr_addr),
        .address_rd(ofmd_rd_addr),
        .din(add_data2_21bits[20:5]), // 16 bits
        .dout(dout_ofmd2)
    );
// -------------------------------

// OFMD read address generator
ofmd_rd_addr #(
    .WIDTH(6),         // Width of the address counter
    .OFMD1_SIZE(OFMD_ADDR_DEPTH_3),  // Size for 6x6 OFMD
    .OFMD2_SIZE(OFMD_ADDR_DEPTH_5)   // Size for 4x4 OFMD
) ofmd_rd_addr_cnter (
    .clk(clk),
    .rst(rst),
    .en(ofmd_rd_en),
    .is_5x5(is_5x5),

    .addr_cnt(ofmd_rd_addr), // 0~35 or 0~15
    .done_rd(ofmd_rd_done)
);

endmodule