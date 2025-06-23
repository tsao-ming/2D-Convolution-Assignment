module ram #(
    parameter DATA_WIDTH = 8,
    parameter WORDS      = 64,
    parameter ADDR_WIDTH = 6    // 2^6
)(
    input                       clk, 
    input                       en, 
    input                       wr,
    input      [ADDR_WIDTH-1:0] address_wr,
    input      [ADDR_WIDTH-1:0] address_rd,
    input      [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    reg [DATA_WIDTH-1:0] ram_data [0:WORDS-1];

    always @(posedge clk) begin
        if (en) begin
            if (~wr) begin
                dout <= ram_data[address_rd]; // read
            end
            else begin
                dout <= {DATA_WIDTH{1'b0}};
                ram_data[address_wr] <= din; // write
            end
        end
        else begin
            dout <= {DATA_WIDTH{1'b0}};
        end
    end

endmodule