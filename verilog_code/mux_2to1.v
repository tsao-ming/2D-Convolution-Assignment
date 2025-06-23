module mux_2to1 #(
    parameter WIDTH = 1
)(
    input   [WIDTH-1:0] data_in_0,
    input   [WIDTH-1:0] data_in_1,
    input               sel,
    output  [WIDTH-1:0] data_out
);
    assign data_out = (sel) ? data_in_1 : data_in_0;

endmodule