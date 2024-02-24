/*------------------------------------------------------------------------------
 * File          : processing_unit_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 23, 2023
 * Description   : Processing Unit's Testbench
 *------------------------------------------------------------------------------*/

module processing_unit_tb;

// Parameters
localparam  				TOTAL_PE 	 = 	4;
localparam					PE_ROW_OR_COL = $sqrt(TOTAL_PE);
		
localparam					NUM_ROWS_COLS =  1;

localparam 			  		SCORE_WIDTH  = 	8;
localparam					SOURCE_WIDTH = 	2;
localparam 					LETTER_WIDTH = 	2;
		
localparam  GAP_PENALTY =  2;
localparam  MATCH 		 = 	1;
localparam  MISMATCH 	 = 	1;


// Input Scores from near PUs
logic  	 [NUM_ROWS_COLS:0][SCORE_WIDTH-1:0]		prev_top_scores;
logic  	 [NUM_ROWS_COLS:0][SCORE_WIDTH-1:0]		prev_left_scores;
logic  	 [SCORE_WIDTH-1:0]						prev_diagonal_scores;


// Input Letters for PEs
logic 	 [NUM_ROWS_COLS:0][LETTER_WIDTH-1:0] 	query_letters;    // the top sequence
logic 	 [NUM_ROWS_COLS:0][LETTER_WIDTH-1:0] 	database_letters; // the left sequence


// Outputs
logic	 [NUM_ROWS_COLS:0][NUM_ROWS_COLS:0][SCORE_WIDTH-1:0]		scores_out;
logic	 [NUM_ROWS_COLS:0][NUM_ROWS_COLS:0]						zero_score_bits;
logic  	 [NUM_ROWS_COLS:0][NUM_ROWS_COLS:0][SOURCE_WIDTH-1:0]		sources;

// Instantiate the module
processing_unit #(
	/*
	.TOTAL_PE(TOTAL_PE),
	.PE_ROW_OR_COL(PE_ROW_OR_COL),
	.NUM_ROWS_COLS(NUM_ROWS_COLS),
	.SCORE_WIDTH(SCORE_WIDTH),
	.SOURCE_WIDTH(SOURCE_WIDTH),
	.LETTER_WIDTH(LETTER_WIDTH)
	*/
) dut (
  .prev_top_scores(prev_top_scores),
  .prev_left_scores(prev_left_scores),
  .prev_diagonal_scores(prev_diagonal_scores),
  .query_letters(query_letters),
  .database_letters(database_letters),
  .scores_out(scores_out),
  .zero_score_bits(zero_score_bits),
  .sources(sources)
);

// Test stimulus
initial begin
  // Test scenario
  prev_top_scores[0] = 0;
  prev_top_scores[1] = 0;
  prev_left_scores[0] = 0;
  prev_left_scores[1] = 0;
  prev_diagonal_scores = 0;
  query_letters[0] = 2'b11;
  query_letters[1] = 2'b10;
  database_letters[0] = 2'b11;
  database_letters[1] = 2'b10;

  #10;
  
  prev_top_scores[0] = 3;
  prev_top_scores[1] = 8;
  prev_left_scores[0] = 0;
  prev_left_scores[1] = 19;
  prev_diagonal_scores = 0;
  query_letters[0] = 2'b00;
  query_letters[1] = 2'b10;
  database_letters[0] = 2'b01;
  database_letters[1] = 2'b10;
  
  #10;
  
  prev_top_scores[0] = 0;
  prev_top_scores[1] = 18;
  prev_left_scores[0] = 3;
  prev_left_scores[1] = 4;
  prev_diagonal_scores = 1;
  query_letters[0] = 2'b01;
  query_letters[1] = 2'b11;
  database_letters[0] = 2'b01;
  database_letters[1] = 2'b10;

  #10;

  // Finish simulation
  $finish;
end

endmodule