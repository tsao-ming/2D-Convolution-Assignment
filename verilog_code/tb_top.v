module tb_top;
    reg clk;
    reg rst;
    reg in_st_ifmd;
    reg [7:0] din;
    reg in_st_kw;
    reg kw_is_5_5;

    // wire [7:0] ifmd1_dout, ifmd2_dout;

    integer i;
    // Declare wires for the FSM outputs
    // wire ifmd_wr_done;
    // wire kw_wr_done;
    // wire is_5x5;
    // wire kw_3x3_in_st;
    // wire kw_5x5_in_st;
    // wire [5:0] ifmd_wr_addr;
    // wire [5:0] ifmd_wr_addr_1, ifmd_wr_addr_2;
    // wire [7:0] ifmd_din1, ifmd_din2;
    // wire ifmd_sel;
    // wire ifmd_ram1_en;
    // wire ifmd_wr1;
    // wire ifmd_ram2_en;
    // wire ifmd_wr2;
    // wire [4:0] kw_3x3_wr_addr;
    // wire [4:0] kw_5x5_wr_addr;
    // wire [4:0] kw_wr_addr;
    // wire [5:0] ifmd_rd_addr_3x3, ifmd_rd_addr_5x5;
    // wire [5:0] ifmd_rd_addr;
    // wire ifmd_rd_done;
    // wire [4:0] kw_rd_addr_3x3, kw_rd_addr_5x5;
    // wire [4:0] kw_rd_addr;
    // wire [7:0] kw1_dout, kw2_dout, kw3_dout, kw4_dout;
    // wire [19:0] mult_out_1, mult_out_2, mult_out_3, mult_out_4;

    // wire [19:0] acc_out_1, acc_out_2, acc_out_3, acc_out_4;
    // wire [5:0] ofmd6x6_wr_addr, ofmd4x4_wr_addr, ofmd_wr_addr;
    // wire [20:0] add_data1_21bits, add_data2_21bits;
    // wire [19:0] accu_we_need_data1, accu_we_need_data2, accu_we_need_data3, accu_we_need_data4;
    wire signed [15:0] dout_ofmd1, dout_ofmd2;
    wire out_st;
    // wire [5:0] ofmd6x6_rd_addr, ofmd4x4_rd_addr;
    // wire [5:0] ofmd_rd_addr;

    top dut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .in_st_ifmd(in_st_ifmd),
        .in_st_kw(in_st_kw),
        .kw_is_5_5(kw_is_5_5),

        .dout_ofmd1(dout_ofmd1),
        .dout_ofmd2(dout_ofmd2),
        .out_st(out_st)
    );

    // // Instantiate the FSM module
    // fsm fsm (
    //     .clk(clk),
    //     .rst(rst),
    //     .in_st_ifmd(in_st_ifmd),
    //     .din(din),
    //     .ifmd_wr_done(ifmd_wr_done),
    //     .in_st_kw(in_st_kw),
    //     .kw_is_5_5(kw_is_5_5),
    //     .kw_wr_done(kw_wr_done),
    //     .calc_done(ifmd_rd_done),
    //     .ofmd_rd_done(ofmd6x6_done_rd || ofmd4x4_done_rd),

    //     // .ifmd_din1(ifmd_din1),
    //     // .ifmd_din2(ifmd_din2),
    //     .ifmd_sel(ifmd_sel),
    //     .ifmd_ram1_en(ifmd_ram1_en),
    //     .ifmd_wr1(ifmd_wr1),
    //     .ifmd_ram2_en(ifmd_ram2_en),
    //     .ifmd_wr2(ifmd_wr2),
    //     .is_5x5(is_5x5),
    //     .kw_3x3_in_st(kw_3x3_in_st),
    //     .kw_5x5_in_st(kw_5x5_in_st),
        

    //     .kw_ram1_en(kw_ram1_en),
    //     .kw_ram2_en(kw_ram2_en),
    //     .kw_ram3_en(kw_ram3_en),
    //     .kw_ram4_en(kw_ram4_en),
    //     .kw_wr1(kw_wr1),
    //     .kw_wr2(kw_wr2),
    //     .kw_wr3(kw_wr3),
    //     .kw_wr4(kw_wr4),
    //     .rd_enable_3x3(rd_enable_3x3),
    //     .rd_enable_5x5(rd_enable_5x5),
    //     .calc_ing(calc_ing),
    //     .delay_calc_ing(delay_calc_ing),
    //     .delay2_calc_ing(delay2_calc_ing),
    //     .delay3_calc_ing(delay3_calc_ing),
    //     .ofmd_6x6_wr_addr_en(ofmd_6x6_wr_addr_en),
    //     .ofmd_4x4_wr_addr_en(ofmd_4x4_wr_addr_en),
    //     .ofmd_rd_en(ofmd_rd_en),
    //     .ofmd_ram_en(ofmd_ram_en)
    // );
    // // Instantiate the counter modules
    // ifmd_wr_addr_cnt ifmd_wr_addr_cnt (
    //     .clk(clk),
    //     .rst(rst),
    //     .in_st(in_st_ifmd),

    //     .count(ifmd_wr_addr),
    //     .ifmd_wr_done(ifmd_wr_done)
    // );
    // // demux_1to2_6bits demux_1to2_ifmd_addr (
    // //     .data_in(ifmd_wr_addr),
    // //     .sel(ifmd_sel),
    // //     .data_out_0(ifmd_wr_addr_1),
    // //     .data_out_1(ifmd_wr_addr_2)
    // // );
    // ram_ifmd ram_ifmd1 (
    //     .clk(clk),
    //     .en(ifmd_ram1_en),
    //     .wr(ifmd_wr1),
    //     .address_wr(ifmd_wr_addr),
    //     .address_rd(ifmd_rd_addr),
    //     .din(din),

    //     .dout(ifmd1_dout)
    // );
    // ram_ifmd ram_ifmd2 (
    //     .clk(clk),
    //     .en(ifmd_ram2_en),
    //     .wr(ifmd_wr2),
    //     .address_wr(ifmd_wr_addr),
    //     .address_rd(ifmd_rd_addr),
    //     .din(din),

    //     .dout(ifmd2_dout)
    // );
    // // demux_1to4_5bits demux_1to4_kw_addr (
    // //     .data_in(ifmd_wr_addr),
    // //     .sel(is_5x5),
    // //     .data_out_0(kw_ram1_addr),
    // //     .data_out_1(kw_ram2_addr),
    // //     .data_out_2(kw_ram3_addr),
    // //     .data_out_3(kw_ram4_addr)
    // // );
    // ram_kw ram_kw1 (
    //     .clk(clk),
    //     .en(kw_ram1_en),
    //     .wr(kw_wr1),
    //     .address_wr(kw_wr_addr),
    //     .address_rd(kw_rd_addr),
    //     .din(din),

    //     .dout(kw1_dout)
    // );
    // ram_kw ram_kw2 (
    //     .clk(clk),
    //     .en(kw_ram2_en),
    //     .wr(kw_wr2),
    //     .address_wr(kw_wr_addr),
    //     .address_rd(kw_rd_addr),
    //     .din(din),

    //     .dout(kw2_dout)
    // );
    // ram_kw ram_kw3 (
    //     .clk(clk),
    //     .en(kw_ram3_en),
    //     .wr(kw_wr3),
    //     .address_wr(kw_wr_addr),
    //     .address_rd(kw_rd_addr),
    //     .din(din),

    //     .dout(kw3_dout)
    // );
    // ram_kw ram_kw4 (
    //     .clk(clk),
    //     .en(kw_ram4_en),
    //     .wr(kw_wr4),
    //     .address_wr(kw_wr_addr),
    //     .address_rd(kw_rd_addr),
    //     .din(din),

    //     .dout(kw4_dout)
    // );

    // kw3x3_wr_addr_cnt kw3x3_wr_addr_cnt (
    //     .clk(clk),
    //     .rst(rst),
    //     .in_st(kw_3x3_in_st),

    //     .count(kw_3x3_wr_addr), // 0~8
    //     .kw_wr_done(kw3x3_wr_done)
    // );
    // kw5x5_wr_addr_cnt kw5x5_wr_addr_cnt (
    //     .clk(clk),
    //     .rst(rst),
    //     .in_st(kw_5x5_in_st),

    //     .count(kw_5x5_wr_addr), // 0~24
    //     .kw_wr_done(kw5x5_wr_done)
    // );
    // or kw_wr_done_or (
    //     kw_wr_done,
    //     kw3x3_wr_done,
    //     kw5x5_wr_done
    // );
    // mux_2to1_5bits mux_kw_addr (
    //     .data_in_0(kw_3x3_wr_addr),
    //     .data_in_1(kw_5x5_wr_addr),
    //     .sel(is_5x5),
    //     .data_out(kw_wr_addr)
    // );

    // ifmd_rd_addr_gener_3x3 ifmd_rd_addr_gener_3x3 (
    //     .clk(clk),
    //     .rst(rst),
    //     .enable(rd_enable_3x3),

    //     .ifmd_rd_addr(ifmd_rd_addr_3x3),
    //     .count9(kw_rd_addr_3x3),
    //     .delay2_every_9(delay2_every_9),
    //     .ifmd_rd_done(ifmd1_rd_done)
    // );
    // ifmd_rd_addr_gener_5x5 ifmd_rd_addr_gener_5x5 (
    //     .clk(clk),
    //     .rst(rst),
    //     .enable(rd_enable_5x5),

    //     .ifmd_rd_addr(ifmd_rd_addr_5x5),
    //     .count25(kw_rd_addr_5x5),
    //     .delay2_every_25(delay2_every_25),
    //     .ifmd_rd_done(ifmd2_rd_done)
    // );
    // or ifmd_rd_done_or (
    //     ifmd_rd_done,
    //     ifmd1_rd_done,
    //     ifmd2_rd_done
    // );
    // mux_2to1_6bits mux_ifmd_rd_addr (
    //     .data_in_0(ifmd_rd_addr_3x3),
    //     .data_in_1(ifmd_rd_addr_5x5),
    //     .sel(is_5x5),
    //     .data_out(ifmd_rd_addr)
    // );
    // mux_2to1_5bits mux_kw_rd_addr (
    //     .data_in_0(kw_rd_addr_3x3),
    //     .data_in_1(kw_rd_addr_5x5),
    //     .sel(is_5x5),
    //     .data_out(kw_rd_addr)
    // );
    
    // mux_2to1_1bit mux_delay2_every (
    //     .data_in_0(delay2_every_9),
    //     .data_in_1(delay2_every_25),
    //     .sel(is_5x5),
    //     .data_out(delay2_every)
    // );

    // multer8x8_signed multer_1 (
    //     .a(ifmd1_dout),
    //     .b(kw1_dout),
    //     .out(mult_out_1)
    // );
    // multer8x8_signed multer_2 (
    //     .a(ifmd2_dout),
    //     .b(kw2_dout),
    //     .out(mult_out_2)
    // );
    // multer8x8_signed multer_3 (
    //     .a(ifmd1_dout),
    //     .b(kw3_dout),
    //     .out(mult_out_3)
    // );
    // multer8x8_signed multer_4 (
    //     .a(ifmd2_dout),
    //     .b(kw4_dout),
    //     .out(mult_out_4)
    // );
    // accumulator acc_1 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(delay_calc_ing),
    //     .data_in(mult_out_1),
    //     .load_new_value(delay2_every), 

    //     .acc_out(acc_out_1) // 0~35
    // );
    // accumulator acc_2 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(delay_calc_ing),
    //     .data_in(mult_out_2),
    //     .load_new_value(delay2_every),

    //     .acc_out(acc_out_2)
    // );
    // accumulator acc_3 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(delay_calc_ing),
    //     .data_in(mult_out_3),
    //     .load_new_value(delay2_every),

    //     .acc_out(acc_out_3)
    // );
    // accumulator acc_4 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(delay_calc_ing),
    //     .data_in(mult_out_4),
    //     .load_new_value(delay2_every),

    //     .acc_out(acc_out_4)
    // );

    // accu_result_reg accu_result_reg1 (
    //     .clk(clk),
    //     .rst(rst),
    //     .acc_out(acc_out_1),
    //     .load_new_value(delay2_every),

    //     .data(accu_we_need_data1)
    // );
    // accu_result_reg accu_result_reg2 (
    //     .clk(clk),
    //     .rst(rst),
    //     .acc_out(acc_out_2),
    //     .load_new_value(delay2_every),

    //     .data(accu_we_need_data2)
    // );
    // accu_result_reg accu_result_reg3 (
    //     .clk(clk),
    //     .rst(rst),
    //     .acc_out(acc_out_3),
    //     .load_new_value(delay2_every),

    //     .data(accu_we_need_data3)
    // );
    // accu_result_reg accu_result_reg4 (
    //     .clk(clk),
    //     .rst(rst),
    //     .acc_out(acc_out_4),
    //     .load_new_value(delay2_every),

    //     .data(accu_we_need_data4)
    // );
    // adder_21bits adder_1 (
    //     .a({accu_we_need_data1[19], accu_we_need_data1}),
    //     .b({accu_we_need_data2[19], accu_we_need_data2}),
    //     .out(add_data1_21bits) // 0~35
    // );
    // adder_21bits adder_2 (
    //     .a({accu_we_need_data3[19], accu_we_need_data3}),
    //     .b({accu_we_need_data4[19], accu_we_need_data4}),
    //     .out(add_data2_21bits) // 0~35
    // );
    
    // ofmd_wr_addr_cnter_6x6 ofmd_wr_addr_cnter_6x6 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(ofmd_6x6_wr_addr_en),
    //     .delay2_every_9(delay2_every),

    //     .addr_cnt(ofmd6x6_wr_addr)      // 0~35
    //     // .done_wr(ofmd6x6_done_wr)
    // );
    // ofmd_wr_addr_cnter_4x4 ofmd_wr_addr_cnter_4x4 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(ofmd_4x4_wr_addr_en),
    //     .delay2_every_25(delay2_every),

    //     .addr_cnt(ofmd4x4_wr_addr)      // 0~15
    //     // .done_wr(ofmd4x4_done_wr)
    // );
    // mux_2to1_6bits mux_ofmd_wr_addr (
    //     .data_in_0(ofmd6x6_wr_addr),
    //     .data_in_1(ofmd4x4_wr_addr),
    //     .sel(is_5x5),

    //     .data_out(ofmd_wr_addr)
    // );

    // ram_ofmd ram_ofmd1 (
    //     .clk(clk),
    //     .en(ofmd_ram_en),
    //     .wr(delay3_calc_ing),
    //     .address_wr(ofmd_wr_addr),
    //     .address_rd(ofmd_rd_addr),
    //     .din(add_data1_21bits[20:5]), 

    //     .dout(dout_ofmd1)
    // );
    // ram_ofmd ram_ofmd2 (
    //     .clk(clk),
    //     .en(ofmd_ram_en),
    //     .wr(delay3_calc_ing),
    //     .address_wr(ofmd_wr_addr),
    //     .address_rd(ofmd_rd_addr),
    //     .din(add_data2_21bits[20:5]), 

    //     .dout(dout_ofmd2) // Not used in this testbench
    // );

    // ofmd_rd_addr_6x6 ofmd_rd_addr_6x6 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(ofmd_rd_en && ~is_5x5), // 6x6 mode

    //     .addr_cnt(ofmd6x6_rd_addr), // 0~35
    //     .done_rd(ofmd6x6_done_rd)
    // );
    // ofmd_rd_addr_4x4 ofmd_rd_addr_4x4 (
    //     .clk(clk),
    //     .rst(rst),
    //     .en(ofmd_rd_en && is_5x5), // 4x4 mode

    //     .addr_cnt(ofmd4x4_rd_addr), // 0~15
    //     .done_rd(ofmd4x4_done_rd)
    // );
    // mux_2to1_6bits mux_ofmd_rd_addr (
    //     .data_in_0(ofmd6x6_rd_addr),
    //     .data_in_1(ofmd4x4_rd_addr),
    //     .sel(is_5x5),

    //     .data_out(ofmd_rd_addr)
    // );
    
    // 4 個 3x3 卷積核，每個獨立一個陣列
    reg [7:0] buffer_3x3_KW0 [0:8];
    reg [7:0] buffer_3x3_KW1 [0:8];
    reg [7:0] buffer_3x3_KW2 [0:8];
    reg [7:0] buffer_3x3_KW3 [0:8];

    // 4 個 5x5 卷積核，每個獨立一個陣列
    reg [7:0] buffer_5x5_KW0 [0:24];
    reg [7:0] buffer_5x5_KW1 [0:24];
    reg [7:0] buffer_5x5_KW2 [0:24];
    reg [7:0] buffer_5x5_KW3 [0:24];

    // 2 張 8x8 輸入特徵圖，每個獨立一個陣列
    reg [7:0] buffer_IFMD0 [0:63];
    reg [7:0] buffer_IFMD1 [0:63];

    initial begin
        $readmemb("./input_data/KW_3x3_1.dat", buffer_3x3_KW0);
        $readmemb("./input_data/KW_3x3_2.dat", buffer_3x3_KW1);
        $readmemb("./input_data/KW_3x3_3.dat", buffer_3x3_KW2);
        $readmemb("./input_data/KW_3x3_4.dat", buffer_3x3_KW3);

        $readmemb("./input_data/KW_5x5_1.dat", buffer_5x5_KW0);
        $readmemb("./input_data/KW_5x5_2.dat", buffer_5x5_KW1);
        $readmemb("./input_data/KW_5x5_3.dat", buffer_5x5_KW2);
        $readmemb("./input_data/KW_5x5_4.dat", buffer_5x5_KW3);

        $readmemb("./input_data/IFM_8x8_1.dat", buffer_IFMD0);
        $readmemb("./input_data/IFM_8x8_2.dat", buffer_IFMD1);
    end
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end
    // Testbench stimulus
    initial begin
        // Initialize inputs
        rst = 0;
        in_st_ifmd = 0;
        din = 8'd0;
        kw_is_5_5 = 1'b0;
        in_st_kw = 0;
        #10;

        // Apply reset
        rst = 1;
        #10;

        in_st_ifmd = 1;
        #20;
        in_st_ifmd = 0;
        for (i = 0; i < 64; i = i + 1) begin    // (i=8) din = 8 + 5 = 13      (i=36) din = 36 + 5 = 41
            @(posedge clk);
            din = buffer_IFMD0[i];
            #10;
        end     // last din = 63+5 = 68
        #50;

        in_st_ifmd = 1;
        #10;
        in_st_ifmd = 0;
        for (i = 0; i < 64; i = i + 1) begin    
            @(posedge clk);
            din = buffer_IFMD1[i];
            #10;
        end     // last din = 63+10 = 73
        #50;
        //////////////////////////////////////////////
        kw_is_5_5 = 1'b1; // Set to mode
        #10;
        in_st_kw = 1;     
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 20 = 28      (i=24) din = 24 + 20 = 44
            @(posedge clk);
            din = buffer_5x5_KW0[i];
            #10;
        end     // last din = 24+20 = 44
        #50;

        in_st_kw = 1;
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 30 = 38
            @(posedge clk);
            din = buffer_5x5_KW1[i];
            #10;
        end     // last din = 24+30 = 54
        #50;

        in_st_kw = 1;
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 40 = 48
            @(posedge clk);
            din = buffer_5x5_KW2[i];
            #10;
        end     // last din = 24+40 = 64
        #50;

        in_st_kw = 1;
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 50 = 58
            @(posedge clk);
            din = buffer_5x5_KW3[i];
            #10;
        end     // last din = 24+50 = 74
        
        #4200;
        // ==================================================================================================
        rst = 0;
        #10;
        rst = 1;

        in_st_ifmd = 1;
        #20;
        in_st_ifmd = 0;
        for (i = 0; i < 64; i = i + 1) begin    // (i=8) din = 8 + 5 = 13      (i=36) din = 36 + 5 = 41
            @(posedge clk);
            din = buffer_IFMD0[i];
            #10;
        end     // last din = 63+5 = 68
        #50;

        in_st_ifmd = 1;
        #10;
        in_st_ifmd = 0;
        for (i = 0; i < 64; i = i + 1) begin    
            @(posedge clk);
            din = buffer_IFMD1[i];
            #10;
        end     // last din = 63+10 = 73
        #50;
        /////////////////////////////////////////////////////
                kw_is_5_5 = 1'b0; // Set to mode
        #10;
        in_st_kw = 1;     
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 20 = 28      (i=24) din = 24 + 20 = 44
            @(posedge clk);
            din = buffer_3x3_KW0[i];
            #10;
        end     // last din = 24+20 = 44
        #50;

        in_st_kw = 1;
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 30 = 38
            @(posedge clk);
            din = buffer_3x3_KW1[i];
            #10;
        end     // last din = 24+30 = 54
        #50;

        in_st_kw = 1;
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 40 = 48
            @(posedge clk);
            din = buffer_3x3_KW2[i];
            #10;
        end     // last din = 24+40 = 64
        #50;

        in_st_kw = 1;
        #10;
        in_st_kw = 0;
        for (i = 0; i < 25; i = i + 1) begin    // (i=8) din = 8 + 50 = 58
            @(posedge clk);
            din = buffer_3x3_KW3[i];
            #10;
        end     // last din = 24+50 = 74
        ////////////////////////////////////////////////////
        #4200;
        // Finish simulation
        $finish;
    end
    initial begin
        $dumpfile("bench_wave.vcd");
        $dumpvars(0, tb_top);
    end
    initial begin
        $monitor("kw_is_5_5: %b, dout_ofmd1: %d, dout_ofmd2: %d",
                 kw_is_5_5, dout_ofmd1, dout_ofmd2);
    end

    wire [7:0] ram_ifmd1_0 = dut.ram_ifmd1.ram_data[0];
    wire [7:0] ram_ifmd1_1 = dut.ram_ifmd1.ram_data[1];
    wire [7:0] ram_ifmd1_2 = dut.ram_ifmd1.ram_data[2];
    wire [7:0] ram_ifmd1_3 = dut.ram_ifmd1.ram_data[3];
    wire [7:0] ram_ifmd1_4 = dut.ram_ifmd1.ram_data[4];
    wire [7:0] ram_ifmd1_5 = dut.ram_ifmd1.ram_data[5];
    wire [7:0] ram_ifmd1_60 = dut.ram_ifmd1.ram_data[60];
    wire [7:0] ram_ifmd1_61 = dut.ram_ifmd1.ram_data[61];
    wire [7:0] ram_ifmd1_62 = dut.ram_ifmd1.ram_data[62];
    wire [7:0] ram_ifmd1_63 = dut.ram_ifmd1.ram_data[63];

    wire [7:0] ram_ifmd2_0 = dut.ram_ifmd2.ram_data[0];
    wire [7:0] ram_ifmd2_1 = dut.ram_ifmd2.ram_data[1];
    wire [7:0] ram_ifmd2_2 = dut.ram_ifmd2.ram_data[2];
    wire [7:0] ram_ifmd2_3 = dut.ram_ifmd2.ram_data[3];
    wire [7:0] ram_ifmd2_4 = dut.ram_ifmd2.ram_data[4];
    wire [7:0] ram_ifmd2_5 = dut.ram_ifmd2.ram_data[5];
    wire [7:0] ram_ifmd2_60 = dut.ram_ifmd2.ram_data[60];
    wire [7:0] ram_ifmd2_61 = dut.ram_ifmd2.ram_data[61];
    wire [7:0] ram_ifmd2_62 = dut.ram_ifmd2.ram_data[62];
    wire [7:0] ram_ifmd2_63 = dut.ram_ifmd2.ram_data[63];

    wire [7:0] ram_kw1_0 = dut.ram_kw1.ram_data[0];
    wire [7:0] ram_kw1_1 = dut.ram_kw1.ram_data[1];
    wire [7:0] ram_kw1_7 = dut.ram_kw1.ram_data[7];
    wire [7:0] ram_kw1_8 = dut.ram_kw1.ram_data[8];
    wire [7:0] ram_kw1_9 = dut.ram_kw1.ram_data[9];
    wire [7:0] ram_kw1_23 = dut.ram_kw1.ram_data[23];
    wire [7:0] ram_kw1_24 = dut.ram_kw1.ram_data[24];

    wire [7:0] ram_kw2_0 = dut.ram_kw2.ram_data[0];
    wire [7:0] ram_kw2_1 = dut.ram_kw2.ram_data[1];
    wire [7:0] ram_kw2_7 = dut.ram_kw2.ram_data[7];
    wire [7:0] ram_kw2_8 = dut.ram_kw2.ram_data[8];
    wire [7:0] ram_kw2_9 = dut.ram_kw2.ram_data[9];
    wire [7:0] ram_kw2_23 = dut.ram_kw2.ram_data[23];
    wire [7:0] ram_kw2_24 = dut.ram_kw2.ram_data[24];

    wire [7:0] ram_kw3_0 = dut.ram_kw3.ram_data[0];
    wire [7:0] ram_kw3_1 = dut.ram_kw3.ram_data[1];
    wire [7:0] ram_kw3_7 = dut.ram_kw3.ram_data[7];
    wire [7:0] ram_kw3_8 = dut.ram_kw3.ram_data[8];
    wire [7:0] ram_kw3_9 = dut.ram_kw3.ram_data[9];
    wire [7:0] ram_kw3_23 = dut.ram_kw3.ram_data[23];
    wire [7:0] ram_kw3_24 = dut.ram_kw3.ram_data[24];

    wire [7:0] ram_kw4_0 = dut.ram_kw4.ram_data[0];
    wire [7:0] ram_kw4_1 = dut.ram_kw4.ram_data[1];
    wire [7:0] ram_kw4_7 = dut.ram_kw4.ram_data[7];
    wire [7:0] ram_kw4_8 = dut.ram_kw4.ram_data[8];
    wire [7:0] ram_kw4_9 = dut.ram_kw4.ram_data[9];
    wire [7:0] ram_kw4_23 = dut.ram_kw4.ram_data[23];
    wire [7:0] ram_kw4_24 = dut.ram_kw4.ram_data[24];

    wire [15:0] ram_ofmd1_0 = dut.ram_ofmd1.ram_data[0];
    wire [15:0] ram_ofmd1_1 = dut.ram_ofmd1.ram_data[1];
    wire [15:0] ram_ofmd1_2 = dut.ram_ofmd1.ram_data[2];
    wire [15:0] ram_ofmd1_14 = dut.ram_ofmd1.ram_data[14];
    wire [15:0] ram_ofmd1_15 = dut.ram_ofmd1.ram_data[15];
    wire [15:0] ram_ofmd1_16 = dut.ram_ofmd1.ram_data[16];
    wire [15:0] ram_ofmd1_34 = dut.ram_ofmd1.ram_data[34];
    wire [15:0] ram_ofmd1_35 = dut.ram_ofmd1.ram_data[35];

endmodule
