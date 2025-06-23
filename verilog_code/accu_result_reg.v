module accu_result_reg (
    input  wire         clk, 
    input  wire         rst, 
    input  wire [19:0]  acc_out,    // 輸入資料
    input               load_new_value,

    output reg  [19:0]  data
);
    reg [19:0] accu_out; // 累加結果
    always @(posedge clk) begin
        if (!rst) begin
            data <= 20'd0;
        end
        else if (load_new_value) begin
            data <= acc_out;
        end
    end
endmodule