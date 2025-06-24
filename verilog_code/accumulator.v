module accumulator #(
    parameter DATA_WIDTH = 20
)(
    input  wire                   clk, 
    input  wire                   rst, 
    input  wire                   en,         // 啟用累加（enable）
    input  wire [DATA_WIDTH-1:0]  data_in,    // 輸入資料
    input                         load_new_value,

    output reg  [DATA_WIDTH-1:0]  acc_out     // 累加結果
);

  always @(posedge clk) begin
    if (!rst) begin
      acc_out <= 0;
    end
    else if (en) begin
      if (load_new_value) begin
        acc_out <= data_in;
      end else begin
        acc_out <= acc_out + data_in;
      end
    end
  end

endmodule
