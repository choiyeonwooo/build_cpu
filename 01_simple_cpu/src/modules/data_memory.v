// data_memory.v

module data_memory #(
  parameter DATA_WIDTH = 32, MEM_ADDR_SIZE = 8
)(
  input  clk,
  input  mem_write,
  input  mem_read,
  input  [1:0] maskmode,
  input  sext,
  input  [DATA_WIDTH-1:0] address,
  input  [DATA_WIDTH-1:0] write_data,

  output reg [DATA_WIDTH-1:0] read_data
);

  // memory
  reg [DATA_WIDTH-1:0] mem_array [0:2**MEM_ADDR_SIZE-1]; // change memory size
  initial $readmemh("data/data_memory.mem", mem_array);
  // wire reg for writedata
  wire [MEM_ADDR_SIZE-1:0] address_internal; // 256 = 8-bit address

  assign address_internal = address[MEM_ADDR_SIZE+1:2]; // 256 = 8-bit address

  // update at negative edge
  always @(negedge clk) begin 
    if (mem_write == 1'b1) begin
      ////////////////////////////////////////////////////////////////////////
      // TODO : Perform writes (select certain bits from write_data
      // according to maskmode
      ////////////////////////////////////////////////////////////////////////
      case (maskmode)
        2'b00: mem_array[address_internal] = write_data[7:0]; //byte
        2'b01: mem_array[address_internal] = write_data[15:0]; //half-word
        2'b10: mem_array[address_internal] = write_data; //word
        default: mem_array[address_internal] = write_data; //word
      endcase
    end
  end

  // combinational logic
  always @(*) begin
    if (mem_read == 1'b1) begin
      ////////////////////////////////////////////////////////////////////////
      // TODO : Perform reads (select bits according to sext & maskmode)
      ////////////////////////////////////////////////////////////////////////
      case (maskmode)
        2'b00: begin
          if(sext == 1'b1) read_data = {{24{1'b0}},mem_array[address_internal][7:0]};//zero-ext
          else read_data = {{24{mem_array[address_internal][7]}}, mem_array[address_internal][7:0]};
        end
        2'b01: begin
          if(sext == 1'b1) read_data = {{16{1'b0}},mem_array[address_internal][15:0]};
          else read_data = {{16{mem_array[address_internal][15]}}, mem_array[address_internal][15:0]};
        end
        2'b10: read_data = mem_array[address_internal];
      endcase
    end else begin
      read_data = 32'h0000_0000;
    end
  end

endmodule
