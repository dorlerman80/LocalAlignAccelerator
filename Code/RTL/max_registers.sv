/*------------------------------------------------------------------------------
 * File          : max_registers.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 6, 2023
 * Description   : 
 *				   
 *------------------------------------------------------------------------------*/
`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module max_registers
import design_variables::*;
/*==============================PARAMS===============================*/
#(
	// Defined in design_variables package
)

/*==============================IN/OUT===============================*/
(
	// CLK & RESET
	input logic 	clk,
	input logic 	rst_n,
	
	// Controller Interface
	input logic 	wr_en_max,

	// Comparison Inputs
	input logic  [COMPARE_UNITS-1:0][N-1:0][SCORE_WIDTH-1:0]   		score_in,
	input logic  [COMPARE_UNITS-1:0][N-1:0][ROW_BITS_WIDTH-1:0]     row_in,
	input logic  [COMPARE_UNITS-1:0][N-1:0][COL_BITS_WIDTH-1:0]     col_in,
	
	// Max Output
	output logic [SCORE_WIDTH-1:0]     		max_score,
	output logic [ROW_BITS_WIDTH-1:0]       max_row,
	output logic [COL_BITS_WIDTH-1:0]       max_col
);

/*===============================LOGIC===============================*/
	
//----------------MAX OF 'COMPARE_UNITS'--------------//

// Maximum of each unit holding 4 values each
logic  [COMPARE_UNITS-1:0][SCORE_WIDTH-1:0]   	   score_of_4; // 'COMPARE_UNITS' values of 'SCORE_WIDTH' bits
logic  [COMPARE_UNITS-1:0][ROW_BITS_WIDTH-1:0]     row_of_4;   // 'COMPARE_UNITS' values of 'ROW_BITS_WIDTH' bits
logic  [COMPARE_UNITS-1:0][COL_BITS_WIDTH-1:0]     col_of_4;   // 'COMPARE_UNITS' values of 'COL_BITS_WIDTH' bits

generate
	for (genvar i = 0; i < COMPARE_UNITS; i++) begin : i_max_of_4
			max_of_n 	
						#(
							.NUM_VALS_TO_COMPARE(N)
						)
					
			max_of_4
						(	
							.score_in(score_in[i]),
							.row_in(row_in[i]),
							.col_in(col_in[i]),
							.max_n_score(score_of_4[i]),
							.max_n_row(row_of_4[i]),
							.max_n_col(col_of_4[i])
						);
	end
endgenerate

// Maximum of 16 units holding the max of 4 values each
logic [SCORE_WIDTH-1:0] 		new_max_score;
logic [ROW_BITS_WIDTH-1:0] 		new_max_row;
logic [COL_BITS_WIDTH-1:0] 		new_max_col;

generate
		max_of_n
					#(	
						.NUM_VALS_TO_COMPARE(M)
					)
		max_of_16
					(
						.score_in(score_of_4),
						.row_in(row_of_4),
						.col_in(col_of_4),
						.max_n_score(new_max_score),
						.max_n_row(new_max_row),
						.max_n_col(new_max_col)
					);
endgenerate
//-------------end MAX OF 'COMPARE_UNITS'-------------//
logic [COL_BITS_WIDTH-1:0] max_col_reg;
logic [ROW_BITS_WIDTH-1:0] max_row_reg;
logic [SCORE_WIDTH-1:0] max_score_reg;
logic en_update;

// COL REG
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n)
		max_col_reg 	<= 	'0;
		
	else if (en_update)
		max_col_reg 	<=	 new_max_col;		
end

assign max_col = max_col_reg;


// ROW REG
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n)
		max_row_reg 	<= 	'0;
		
	else if (en_update)
		max_row_reg 	<=	 new_max_row;		
end

assign max_row = max_row_reg;


// SCORE REG
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n)
		max_score_reg 	<= 	'0;
		
	else if (en_update)
		max_score_reg 	<=	 new_max_score;		
end

assign max_score = max_score_reg;



//--------------------UPDATE ENABLE-------------------//
assign en_update = ((new_max_score > max_score_reg) && wr_en_max) ? 1'b1 : 1'b0;




endmodule
