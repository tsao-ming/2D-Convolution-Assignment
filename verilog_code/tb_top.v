module tb_top;
    reg clk;
    reg rst;
    reg in_st_ifmd;
    reg [7:0] din;
    reg in_st_kw;
    reg kw_is_5_5;

    integer i;
    
    wire signed [15:0] dout_ofmd1, dout_ofmd2;
    wire out_st;

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
