module ofmd_rd_addr #(
    parameter WIDTH         = 6,     // Width of the address counter
    parameter OFMD1_SIZE    = 36,    // Size for 6x6 OFMD
    parameter OFMD2_SIZE    = 16     // Size for 4x4 OFMD
)(
    input                   clk,
    input                   rst,
    input                   en,
    input                   is_5x5,
    output reg [WIDTH-1:0]  addr_cnt, 
    output                  done_rd
);
    wire [WIDTH-1:0] max_addr = is_5x5 ? OFMD2_SIZE-1 : OFMD1_SIZE-1;

    always @(posedge clk) begin
        if (!rst) begin
            addr_cnt <= {WIDTH{1'b0}}; 
        end
        else if (en) begin
            if ( done_rd ) begin
                addr_cnt <= {WIDTH{1'b0}}; 
            end
            else begin
                addr_cnt <= addr_cnt + 1'b1;
            end
        end
    end
    assign done_rd = (addr_cnt == max_addr);
endmodule