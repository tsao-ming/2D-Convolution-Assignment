module accumulator (
    input  wire         clk, 
    input  wire         rst, 
    input  wire         en,         // 啟用累加（enable）
    input  wire [19:0]  data_in,    // 輸入資料
    input               load_new_value,

    output reg  [19:0]  acc_out     // 累加結果
    // output reg  [19:0]  acc_out_we_need
);

  always @(posedge clk) begin
    if (!rst) begin
      acc_out <= 20'd0;
      // acc_out_we_need <= 20'd0;
    end
    else if (en) begin
      if (load_new_value) begin
        acc_out <= data_in;
        // acc_out_we_need <= acc_out;
      end else begin
        acc_out <= acc_out + data_in;
      end
    end
  end

endmodule
