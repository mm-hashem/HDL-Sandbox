module alu
(
  input wire [3:0] a, b,
  input wire [7:0] opcode,
  output reg [7:0] _output
);


always @*
begin
  case (opcode)
    // arithmetic
    8'h00: _output = a + b;
    8'h01: _output = a - b;
    8'h02: _output = a * b;
    8'h03: _output = a / b;
    8'h04: _output = a % b;
    8'h05: _output = a ** b;

    // bitwise
    8'h06: _output = a & b;
    8'h07: _output = a | b;
    8'h08: _output = a ^ b;

    //concatenation
    8'h09: _output = {a, b};

    // logical shift
    8'h0A: _output = a << b;
    8'h0B: _output = a >> b;

    // arithmetic shift
    8'h0C: _output = a <<< b;
    8'h0D: _output = a >>> b;

    // relational
    8'h0E: _output = (a >= b) ? 8'h01 : 8'h00;
    8'h0F: _output = (a === b) ? 8'h01 : 8'h00;

    default: _output = 8'h00;
  endcase
end

endmodule
