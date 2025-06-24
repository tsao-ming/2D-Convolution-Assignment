module accu_result_reg #(
    parameter DATA_WIDTH = 20
)(
    input  wire         clk, 
    input  wire         rst, 
    input  wire [DATA_WIDTH-1:0]  acc_out,    // 輸入資料
    input               load_new_value,

    output reg  [DATA_WIDTH-1:0]  data
);
    reg [DATA_WIDTH-1:0] accu_out; // 累加結果
    always @(posedge clk) begin
        if (!rst) begin
            data <= 0;
        end
        else if (load_new_value) begin
            data <= acc_out;
        end
    end
endmodule