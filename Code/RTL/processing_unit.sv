/*------------------------------------------------------------------------------
 * File          : processing_unit.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 6, 2023
 * Description   : Processing Unit Logic.
 * 				   Computes all the required calculations of the substitution matrix.
 *------------------------------------------------------------------------------*/
`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module processing_unit
import design_variables::*;
/*==============================PARAMS===============================*/
#(
	// Defined in design_variables package
)	

/*==============================IN/OUT===============================*/
(
	// Input Scores from near PUs
	input logic  	 [NUM_COLS_PE-1:0][SCORE_WIDTH-1:0]			prev_top_scores,
	input logic  	 [NUM_ROWS_PE-1:0][SCORE_WIDTH-1:0]			prev_left_scores,
	input logic  	 [SCORE_WIDTH-1:0]							prev_diagonal_scores,
	
	
	// Input Letters for PEs
	input logic 	 [NUM_COLS_PE-1:0][LETTER_WIDTH-1:0] 		query_letters,    // the top sequence
	input logic 	 [NUM_ROWS_PE-1:0][LETTER_WIDTH-1:0] 		database_letters, // the left sequence
	
	
	// Outputs
	output logic	 [NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0]	scores_out,
	output logic	 [NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0]						zero_score_bits,
	output logic  	 [NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SOURCE_WIDTH-1:0]	sources
);

/*===============================LOGIC===============================*/
logic	 [NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0] scores;

assign scores_out = scores;

/*===========================INSTANTIATION===========================*/
// Iterating and making all 'NUM_PE_IN_PU' PEs. Instantiation following the row and column.

generate
	for (genvar i = 0; i < NUM_ROWS_PE; i++) begin : pe_row
		for (genvar j = 0; j < NUM_COLS_PE; j++) begin : pe_column
			if (i == 0) begin : pe_row_0_column_j
				if (j == 0) begin : pe_row_0_column_0
						processing_element
										#(

										)
								pe_inst (
											.top(prev_top_scores[0]),
											.left(prev_left_scores[0]),
											.diagonal(prev_diagonal_scores),
											.query_letter(query_letters[0]),
											.database_letter(database_letters[0]),
											.score(scores[i][j]),
											.zero_score_bit(zero_score_bits[i][j]),
											.source(sources[i][j]));
				end
				else begin : pe_row_0_column_j
						processing_element
										#(

										)
								pe_inst (	
											.top(prev_top_scores[j]),
											.left(scores[0][j-1]),
											.diagonal(prev_top_scores[j-1]),
											.query_letter(query_letters[j]),
											.database_letter(database_letters[0]),
											.score(scores[i][j]),
											.zero_score_bit(zero_score_bits[i][j]),
											.source(sources[i][j]));		
				end
			end
			else if (j == 0) begin : pe_column_0
				if (i != 0) begin : pe_row_i_column_0
						processing_element	
										#(

										)
								pe_inst (	
											.top(scores[i-1][j]),
											.left(prev_left_scores[i]),
											.diagonal(prev_left_scores[i-1]),
											.query_letter(query_letters[0]),
											.database_letter(database_letters[i]),
											.score(scores[i][j]),
											.zero_score_bit(zero_score_bits[i][j]),
											.source(sources[i][j]));
											
				end
			end
			else begin : pe_row_i_column_j
					processing_element	
									#(

									)
								pe_inst (
										.top(scores[i-1][j]),
										.left(scores[i][j-1]),
										.diagonal(scores[i-1][j-1]),
										.query_letter(query_letters[j]),
										.database_letter(database_letters[i]),
										.score(scores[i][j]),
										.zero_score_bit(zero_score_bits[i][j]),
										.source(sources[i][j]));
			end
		end
	end
endgenerate

endmodule
