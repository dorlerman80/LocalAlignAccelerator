/*------------------------------------------------------------------------------
 * File          : processing_element_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 20, 2023
 * Description   : Processing Element's Testbench
 *------------------------------------------------------------------------------*/

module processing_element_tb;

// Parameters
parameter WIDTH = 8;
parameter  GAP_PENALTY = 2;
parameter  MATCH = 1;
parameter  MISMATCH = 1;

// Signals
logic [WIDTH-1:0] left;
logic [WIDTH-1:0] top;
logic [WIDTH-1:0] diagonal;
logic [1:0] query_letter;
logic [1:0] database_letter;
logic [WIDTH-1:0] score;
logic zero_score_bit;
logic [1:0] source;

// Instantiate the module
processing_element #(
	/*
	.SCORE_WIDTH(WIDTH),
	.GAP_PENALTY(GAP_PENALTY),
	.MATCH(MATCH),
	.MISMATCH(MISMATCH)
	*/
) dut (
	.left(left),
	.top(top),
	.diagonal(diagonal),
	.query_letter(query_letter),
	.database_letter(database_letter),
	.score(score),
	.zero_score_bit(zero_score_bit),
	.source(source)
);

// Test stimulus
initial begin
	left = 0;
	top = 0;
	diagonal = 0;
	query_letter = 2'b10;
	database_letter = 2'b01;
	#30;

	// Test case 1
	left = 2;
	top = 0;
	diagonal = 1;
	query_letter = 2'b11;
	database_letter = 2'b11;
	#30;

	// Test case 2
	left = 3;
	top = 4;
	diagonal = 0;
	query_letter = 2'b00;
	database_letter = 2'b10;
	#30;

	// Finish simulation
	$finish;
end

endmodule