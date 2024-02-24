/*------------------------------------------------------------------------------
 * File          : traceback_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 28, 2023
 * Description   : Traceback's Teatbench
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module traceback_tb;
import design_variables::*; 

// Parameters
localparam DIAGONAL = 2'b00;
localparam TOP = 2'b11;
localparam LEFT = 2'b01;
localparam LINE = 3'b100;

// Inputs
logic clk;
logic rst_n;
logic en_traceback;
logic start_of_traceback;
logic [SEQ_LENGTH_W-1:0] max_row;
logic [SEQ_LENGTH_W-1:0] max_col;
logic [DATA_PACKET_SIZE-1:0] data_packet;
logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] query_seq_rd;
logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] database_seq_rd;

// Outputs
logic [SEQ_LENGTH_W-1:0] next_row;
logic [SEQ_LENGTH_W-1:0] next_col;
logic finished;
logic [LETTER_WIDTH:0] query_seq_out;
logic [LETTER_WIDTH:0] database_seq_out;

// Instantiate the module
traceback  #()
dut (
  .clk(clk),
  .rst_n(rst_n),
  .en_traceback(en_traceback),
  .start_of_traceback(start_of_traceback),
  .max_row(max_row),
  .max_col(max_col),
  .data_packet(data_packet),
  .query_seq_rd(query_seq_rd),
  .database_seq_rd(database_seq_rd),
  .next_row(next_row),
  .next_col(next_col),
  .finished(finished),
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
  clk = 1'b0;
  rst_n = 1'b0;
  en_traceback = 1'b0;
  start_of_traceback = 1'b0;
  max_row = 5'd0;
  max_col = 5'd0;
  data_packet = 3'b000;
  query_seq_rd = 64'd0;
  database_seq_rd = 64'd0;

  #5
		  
  rst_n = 1'b1; // Release reset
  
  #10
  query_seq_rd = 64'b1000110111001001001110001101110010010011100011011100100100111000; // ATCAGTACGCATCAGTACGCATCAGTACGCAT
  database_seq_rd = 64'b0011100011100011100011100011100011100011100011100011100011100011; // CATCATCATCATCATCATCATCATCATCATCA
  en_traceback = 1'b1;
  start_of_traceback = 1'b1;
  max_row = 5'd9;
  max_col = 5'd14;
  
  #10
		  
  start_of_traceback = 1'b0;

  // Test case
  data_packet = {1'b0, DIAGONAL};
  #10;
  
  data_packet = {1'b0, LEFT};
  #10
  
  data_packet = {1'b0, DIAGONAL};
  #10
		  
  data_packet = {1'b0, DIAGONAL};
  #10
  
  data_packet = {1'b0, TOP};
  #10
		  
  data_packet = {1'b0, DIAGONAL};
  #10
  
  data_packet = {1'b0, LEFT};
  #10
  
  data_packet = {1'b1, DIAGONAL};
  #10

  // Finish simulation
  $finish;
end

endmodule