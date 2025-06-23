module multer8x8_signed #(
    parameter WIDTH = 8,
    parameter OUT_WIDTH = 20 // 8 + 8 + 4 (sign extension)
)(
    input       [WIDTH-1:0]     a,
    input       [WIDTH-1:0]     b, // 8 bits
    output reg  [OUT_WIDTH-1:0] out // 20 bits
);

    // 依據 WIDTH 自動 sign extension
    localparam EXT_WIDTH = OUT_WIDTH - WIDTH;

    always @(a or b) begin
        out = { {EXT_WIDTH{a[WIDTH-1]}}, a } * { {EXT_WIDTH{b[WIDTH-1]}}, b };
    end
    
endmodule