/*------------------------------------------------------------------------------
 * File          : processing_element.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 6, 2023
 * Description   : Processing Element Logic.
 * 				   Implements the required calculations for a single cell of the substitution matrix.
 *------------------------------------------------------------------------------*/

`include "./design_variables.vh"

module processing_element
import design_variables::*;
#()

/*==============================IN/OUT===============================*/
(
	// Scores Inputs
	input logic [SCORE_WIDTH-1:0] 	left,
	input logic [SCORE_WIDTH-1:0] 	top,
	input logic [SCORE_WIDTH-1:0] 	diagonal,
	
	// Letters Inputs
	input logic [LETTER_WIDTH-1:0] 	query_letter,
	input logic [LETTER_WIDTH-1:0] 	database_letter,
	
	// Outputs
	output logic [SCORE_WIDTH-1:0] 	score,
	output logic 			 		zero_score_bit,
	output logic [SOURCE_WIDTH-1:0] source
);

/*==============================SIGNALS==============================*/
logic [SCORE_WIDTH-1:0] left_score;
logic [SCORE_WIDTH-1:0] top_score;
logic [SCORE_WIDTH-1:0] diagonal_score;
logic [SCORE_WIDTH-1:0] diagonal_mismatch_temp;

/*===============================LOGIC===============================*/
assign left_score = (left > GAP_PENALTY) ? (left - GAP_PENALTY) : '0;
assign top_score = (top > GAP_PENALTY) ? (top - GAP_PENALTY) : '0;
assign diagonal_mismatch_temp = (diagonal > MISMATCH) ? (diagonal - MISMATCH) : '0;
assign diagonal_score = (query_letter == database_letter) ? (diagonal + MATCH) : diagonal_mismatch_temp;

max #() max_inst
(
	.top(top_score),
	.left(left_score),
	.diagonal(diagonal_score),
	.max(score),
	.source(source)
 );

assign zero_score_bit =	|score ? 1'b0 : 1'b1;

endmodule
