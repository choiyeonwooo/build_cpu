// imm_generator.v

module imm_generator #(
  parameter DATA_WIDTH = 32
)(
  input [31:0] instruction,

  output reg [DATA_WIDTH-1:0] sextimm
);
wire [6:0] opcode;
wire [2:0] funct3;
assign opcode = instruction[6:0];
assign funct3 = instruction[14:12];
always @(*) begin
  casex (opcode)
    //////////////////////////////////////////////////////////////////////////
    // TODO : Generate sextimm using instruction
    //////////////////////////////////////////////////////////////////////////
    7'b0010011: begin
      if (funct3==3'b011) sextimm = {{20{1'b0}}, instruction[31:20]};
      else if (funct3[0]==1'b1) begin
        if (instruction[30]==1'b1) sextimm = {{27{instruction[24]}},instruction[24:20]}; 
        else sextimm = {{27{1'b0}},instruction[24:20]};
      end
      else sextimm = {{20{instruction[31]}}, instruction[31:20]};
    end
    //lw
    7'b0000011: begin
      if (funct3[2]==1'b1) sextimm = {{20{1'b0}},instruction[31:20]}; 
      else sextimm = $signed(instruction[31:20]);
    end
    //sw
    7'b0100011: sextimm = $signed({instruction[31:25],instruction[11:7]});
    //branch
    7'b1100011: begin
      if (funct3[2:1]==2'b11) sextimm = {{19{1'b0}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0};
      else sextimm ={{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b0}; 
    end
    //jump&link
    7'b1101111: sextimm = {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0};
    //jump&link reg
    7'b1100111: begin
      if (funct3[2:1]==2'b11) sextimm = {{20{1'b0}}, instruction[31:20]};
      else sextimm = {{20{instruction[31]}}, instruction[31:20]};
    end
    default:    sextimm = 32'h0000_0000;
  endcase
end


endmodule
