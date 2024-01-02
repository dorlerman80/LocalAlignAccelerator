/*------------------------------------------------------------------------------
 * File          : max_of_n.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 6, 2023
 * Description   : 
 *				   
 *------------------------------------------------------------------------------*/
`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module max_of_n
import design_variables::*;
/*==============================PARAMS===============================*/
#(
	parameter NUM_VALS_TO_COMPARE = 16
	// Defined in design_variables package
)
/*==============================IN/OUT===============================*/
(
	// INPUTS
	input logic  [NUM_VALS_TO_COMPARE-1:0][SCORE_WIDTH-1:0]      	score_in, // 'NUM_VALS_TO_COMPARE' values of 'SCORE_WIDTH' bits
	input logic  [NUM_VALS_TO_COMPARE-1:0][ROW_BITS_WIDTH-1:0] 	    row_in,	  // 'NUM_VALS_TO_COMPARE' values of 'ROW_BITS_WIDTH' bits	
	input logic  [NUM_VALS_TO_COMPARE-1:0][COL_BITS_WIDTH-1:0] 	    col_in,	  // 'NUM_VALS_TO_COMPARE' values of 'COL_BITS_WIDTH' bits
	
	// OUTPUTS
	output logic [SCORE_WIDTH-1:0]     		max_n_score,
	output logic [ROW_BITS_WIDTH-1:0]       max_n_row,
	output logic [COL_BITS_WIDTH-1:0]       max_n_col
);


/*===============================LOGIC===============================*/
logic [SCORE_WIDTH-1:0] 		cur_score;
logic [ROW_BITS_WIDTH-1:0] 		cur_row;
logic [COL_BITS_WIDTH-1:0] 		cur_col;

always_comb begin
	cur_score = score_in[0];
	cur_row = row_in[0];
	cur_col = col_in[0];
	
	for (int i = 1; i < NUM_VALS_TO_COMPARE; i++) begin
		if (score_in[i] > cur_score) begin
			cur_score 	= 	score_in[i];
			cur_row 	= 	row_in[i];
			cur_col 	= 	col_in[i];
		end
	end
end

assign max_n_score	=	cur_score;
assign max_n_row	=	cur_row;
assign max_n_col	=	cur_col;

endmodule
