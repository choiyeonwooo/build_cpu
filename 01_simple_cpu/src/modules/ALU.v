// ALU.v

// This module performs ALU operations according to the "alu_func" value,
// which is generated by the ALU control unit.
// Note that there exist 10 R-type instructions in RV32I:
// add, sub, xor, or, and, sll, srl, sra, slt, sltu

`include "defines.v"

module ALU 
#(parameter DATA_WIDTH = 32)(
  input [DATA_WIDTH-1:0] in_a, 
  input [DATA_WIDTH-1:0] in_b,
  input [3:0] alu_func,

  output reg [DATA_WIDTH-1:0] result,
  output reg check 
);

// combinational logic 
always @(*) begin
  case (alu_func)
    `OP_ADD:  result = in_a +  in_b; 
    `OP_SUB:  result = in_a -  in_b;
    `OP_XOR:  result = in_a ^  in_b;
    `OP_OR:   result = in_a |  in_b;
    `OP_AND:  result = in_a &  in_b;

    //////////////////////////////////////////////////////////////////////////
    // TODO : Add other operations
    // - The example below is given as a hint
    // - `OP_SRA: result = $signed(in_a) >>> in_b[4:0];
    //////////////////////////////////////////////////////////////////////////
    `OP_SLL: result = in_a << in_b;
    `OP_SRL: result = in_a >>> in_b;
    `OP_SRA: result = $signed(in_a) >>> $signed(in_b);
    `OP_SLT: result = ($signed(in_a) < $signed(in_b))? 32'h0000_0001:32'h0000_0000;
    `OP_SLTU: result = (in_a < in_b)? 32'h0000_0001:32'h0000_0000;
    `OP_BGE: result = ($signed(in_a) < $signed(in_b))? 32'h0000_0001:32'h0000_0000;
    `OP_BGEU: result = (in_a < in_b)? 32'h0000_0001:32'h0000_0000;
    default:  result = 32'h0000_0000;
  endcase
end
// combinational logic
always @(*) begin
  case (alu_func)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Generate check signal
    //////////////////////////////////////////////////////////////////////////
    `OP_SUB: check = (result == 0)? 1'b1:1'b0;
    `OP_BGE: check = result[0];
    `OP_BGEU: check = result[0];
    default:  check = 1'b0;
  endcase
end
endmodule
