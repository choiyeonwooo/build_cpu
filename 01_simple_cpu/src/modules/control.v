// control.v

// The main control module takes as input the opcode field of an instruction
// (i.e., instruction[6:0]) and generates a set of control signals.

module control(
  input [6:0] opcode,

  output [1:0] jump,
  output branch,
  output mem_read,
  output mem_to_reg,
  output [1:0] alu_op,
  output mem_write,
  output alu_src,
  output reg_write
);

reg [9:0] controls;

// combinational logic
always @(*) begin
  casex (opcode)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Implement signals for other instruction types
    //////////////////////////////////////////////////////////////////////////
    7'b0110011: controls = 10'b00_000_10_001; // R-type
    7'b0010011: controls = 10'b00_000_11_011; // I-type
    7'b0x00011: controls = {2'b00,1'b0,{2{~opcode[5]}},2'b00,opcode[5],1'b1,~opcode[5]}; // lw, sw
    7'b1100011: controls = 10'b00_100_01_000; //branch
    7'b110x111: controls = {1'b1,opcode[3],1'b0,~opcode[3],6'b0_01_101}; //jump reg(0) acc(1)
    default:    controls = 10'b00_000_00_000;
  endcase
end

assign {jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write} = controls;

endmodule
