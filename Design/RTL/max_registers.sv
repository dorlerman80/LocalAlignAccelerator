/*------------------------------------------------------------------------------
 * File          : max_registers.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 6, 2023
 * Description   : 
 *				   
 *------------------------------------------------------------------------------*/
`include "./design_variables.vh"

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
	input logic 	start,

	// Comparison Inputs
	input logic  [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][SCORE_WIDTH-1:0]   	   score_in,
	input logic  [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][ROW_BITS_WIDTH-1:0]     row_in,
	input logic  [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][COL_BITS_WIDTH-1:0]     col_in,
	
	// Max Output
	output logic [SCORE_WIDTH-1:0]     		max_score,
	output logic [ROW_BITS_WIDTH-1:0]       max_row,
	output logic [COL_BITS_WIDTH-1:0]       max_col
);

/*===============================SIGNALS=============================*/

// 'COMPARE_UNITS_LVL_1' vectors each holding the max out of 4(holding index and value)  - LEVEL 1
logic  [COMPARE_UNITS_LVL_1-1:0][SCORE_WIDTH-1:0]   	 score_of_4_lvl_1;
logic  [COMPARE_UNITS_LVL_1-1:0][ROW_BITS_WIDTH-1:0]     row_of_4_lvl_1;  
logic  [COMPARE_UNITS_LVL_1-1:0][COL_BITS_WIDTH-1:0]     col_of_4_lvl_1; 

// 'COMPARE_UNITS_LVL_2' vectors each holding the max out of 4(holding index and value) - LEVEL 2
logic  [COMPARE_UNITS_LVL_2-1:0][SCORE_WIDTH-1:0]   	 score_of_4_lvl_2;
logic  [COMPARE_UNITS_LVL_2-1:0][ROW_BITS_WIDTH-1:0]     row_of_4_lvl_2;  
logic  [COMPARE_UNITS_LVL_2-1:0][COL_BITS_WIDTH-1:0]     col_of_4_lvl_2;

// holding index and value of cur max
logic [SCORE_WIDTH-1:0] 		new_max_score;
logic [ROW_BITS_WIDTH-1:0] 		new_max_row;
logic [COL_BITS_WIDTH-1:0] 		new_max_col;

// max index registers
logic [COL_BITS_WIDTH-1:0] max_col_reg;
logic [ROW_BITS_WIDTH-1:0] max_row_reg;
logic [SCORE_WIDTH-1:0]    max_score_reg;

// update
logic en_update;

/*===============================LOGIC===============================*/
	
//==============MAX OF 'COMPARE_UNITS_LVL_1'============//
// Maximum of each unit holding 4 values each - LEVEL 1
generate
	for (genvar i = 0; i < COMPARE_UNITS_LVL_1; i++) begin : max_of_4_lvl_1
			max_of_n 	
						#(
							.NUM_VALS_TO_COMPARE(NUM_VALS_LVL_1)
						)
					
			max_of_4
						(	
							.score_in(score_in[i]),
							.row_in(row_in[i]),
							.col_in(col_in[i]),
							.max_n_score(score_of_4_lvl_1[i]),
							.max_n_row(row_of_4_lvl_1[i]),
							.max_n_col(col_of_4_lvl_1[i])
						);
	end
endgenerate

// Maximum of each unit holding 4 values each - LEVEL 2
generate
	for (genvar i = 0; i < COMPARE_UNITS_LVL_2; i++) begin : max_of_4_lvl_2
			max_of_n 	
						#(
							.NUM_VALS_TO_COMPARE(NUM_VALS_LVL_2)
						)
					
			max_of_4
						(	
							.score_in(score_of_4_lvl_1[i*NUM_VALS_LVL_2 +:NUM_VALS_LVL_2]),
							.row_in(row_of_4_lvl_1[i*NUM_VALS_LVL_2 +:NUM_VALS_LVL_2]),
							.col_in(col_of_4_lvl_1[i*NUM_VALS_LVL_2 +:NUM_VALS_LVL_2]),
							.max_n_score(score_of_4_lvl_2[i]),
							.max_n_row(row_of_4_lvl_2[i]),
							.max_n_col(col_of_4_lvl_2[i])
						);
	end
endgenerate


// Maximum of 4 values - LEVEL 3
generate
		max_of_n
						#(	
							.NUM_VALS_TO_COMPARE(NUM_VALS_LVL_3)
						)
		max_of_4_lvl_3
						(
							.score_in(score_of_4_lvl_2),
							.row_in(row_of_4_lvl_2),
							.col_in(col_of_4_lvl_2),
							.max_n_score(new_max_score),
							.max_n_row(new_max_row),
							.max_n_col(new_max_col)
						);
endgenerate
//==================Registers Update================//

// COL REG
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n)
		max_col_reg 	<= 	'0;
	else if (start)
		max_col_reg 	<= 	'0;	
	else if (en_update)
		max_col_reg 	<=	 new_max_col;		
end

assign max_col = max_col_reg;


// ROW REG
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n)
		max_row_reg 	<= 	'0;
	else if (start)
		max_row_reg 	<= 	'0;		
	else if (en_update)
		max_row_reg 	<=	 new_max_row;		
end

assign max_row = max_row_reg;


// SCORE REG
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n)
		max_score_reg 	<= 	'0;
	else if (start)
		max_score_reg 	<= 	'0;	
	else if (en_update)
		max_score_reg 	<=	 new_max_score;		
end

assign max_score = max_score_reg;


//===================UPDATE ENABLE==================//
assign en_update = ((new_max_score > max_score_reg) && wr_en_max);

endmodule

