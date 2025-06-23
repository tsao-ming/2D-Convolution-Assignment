module adder_21bits #(
    parameter WIDTH = 21
)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    
    output [WIDTH-1:0] out
);
    assign out = a + b;
endmodule