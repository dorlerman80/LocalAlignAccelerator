/*------------------------------------------------------------------------------
 * File          : sequence_buffer_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 13, 2023
 * Description   : Sequence Buffer's Testbench
 *------------------------------------------------------------------------------*/

module sequence_buffer_tb;

// Parameters
localparam INPUT_WIDTH = 8;
localparam LETTER_WIDTH = 2;
localparam NUM_REG = 8;
localparam BITS_REG = 8;

// Clock and Reset
logic clk;
logic rst_n;

// Controller Interface
logic wr_en_buff;

// Design Input
logic [INPUT_WIDTH-1:0] query_seq_in;
logic [INPUT_WIDTH-1:0] database_seq_in;
logic [$clog2(NUM_REG)-1:0] count;

// Output
logic [NUM_REG-1:0] [BITS_REG-1:0]	query_seq_out;
logic [NUM_REG-1:0] [BITS_REG-1:0]	database_seq_out;

// Instantiate the module
sequence_buffer #(
	/*
  .INPUT_WIDTH(INPUT_WIDTH),
  .LETTER_WIDTH(LETTER_WIDTH),
  .NUM_REG(NUM_REG),
  .BITS_REG(BITS_REG)
  */
) dut (
  .clk(clk),
  .rst_n(rst_n),
  .wr_en_buff(wr_en_buff),
  .query_seq_in(query_seq_in),
  .database_seq_in(database_seq_in),
  .count(count),
  .query_seq_out(query_seq_out),
  .database_seq_out(database_seq_out)
);

// Clock generation
always begin
  #5 clk = ~clk;
end

// Test stimulus
initial begin
  // Initialize inputs
  clk = 0;
  rst_n = 0;
  wr_en_buff = 0;
  query_seq_in = 0;
  database_seq_in = 0;
  count = 0;

  // Apply reset
  rst_n = 0;
  #10;

  // Enable Write
  rst_n = 1;
  wr_en_buff = 1;

  // Test scenario
  count = 0;
  query_seq_in = 8'b10011100;
  database_seq_in = 8'b10111011;
  #10;
  count = 1;
  query_seq_in = 8'b11001000;
  database_seq_in = 8'b10011100;
  #10;
  count = 2;
  query_seq_in = 8'b00001011;
  database_seq_in = 8'b10010100;
  #10;
  count = 3;
  query_seq_in = 8'b10100011;
  database_seq_in = 8'b10011100;
  #10;
  count = 4;
  query_seq_in = 8'b10111011;
  database_seq_in = 8'b10111011;
  #10;
  count = 5;
  query_seq_in = 8'b00001101;
  database_seq_in = 8'b10011110;
  #10;
  count = 6;
  query_seq_in = 8'b10110011;
  database_seq_in = 8'b10011100;
  #10;
  count = 7;
  query_seq_in = 8'b01011010;
  database_seq_in = 8'b10011100;
  #10;

  // Finish simulation
  $finish;
end

endmodule