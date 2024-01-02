/*------------------------------------------------------------------------------
 * File          : top.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Aug 18, 2023
 * Description   : Top Unit
 *------------------------------------------------------------------------------*/
`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module top 
import design_variables::*;
#(
/*===================================PARAMS===================================*/	
)
// Defined in design_variables package
(
/*===================================IN/OUT===================================*/
	// Clock & reset
	input logic			clk,
	input logic         rst_n,
	
	// Inputs
	input logic												start,
	input logic  [INPUT_WIDTH-1:0]              			query_seq_in,
	input logic  [INPUT_WIDTH-1:0]              			database_seq_in,
	input logic												inverter_in,
	input logic												flipflop_in,
	
	// Outputs
	output logic											ready,
	output logic [LETTER_WIDTH:0]							query_seq_out,
	output logic [LETTER_WIDTH:0]							database_seq_out,
	output logic [SCORE_WIDTH-1:0]							score,
	output logic											output_valid,
	output logic											inverter_out,
	output logic											flipflop_out
);

/*=================================SIGNALS==================================*/
// Controller Inputs
logic 	[SEQ_LENGTH_W-1:0]							next_row;
logic 	[SEQ_LENGTH_W-1:0]							next_col;
logic												finished;

// Controller Outputs
logic                       										wr_en_buff;
logic [BUFF_CNT_W-1:0]     											count_buff;
logic 																wr_en_max;
logic [NUM_PU-2:0][1:0]												top_sel;															
logic [NUM_PU-2:0][1:0]												left_sel;													
logic [NUM_PU-2:0][1:0]												diagonal_sel;
logic [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][SEQ_LENGTH_W-1:0]		query_letter_sel;
logic [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][SEQ_LENGTH_W-1:0]		database_letter_sel;
logic [NUM_PU-1:0] 													wr_en_pu;
logic [COMPARE_UNITS-1:0][N-1:0][ROW_BITS_WIDTH-1:0]     			row_in;				 
logic [COMPARE_UNITS-1:0][N-1:0][COL_BITS_WIDTH-1:0]     			col_in;
logic [NUM_DIAGONALS-1:0]											write_ctl;
logic [NUM_DIAGONALS_W-1:0] 										choose_diagonal;
logic [NUM_PU_MAIN_DIAGONAL_W-1:0]  								choose_pu;
logic [NUM_PE_IN_PU_W-1:0]											choose_pe;
logic 																en_traceback;
logic 																start_of_traceback;

// Sequence Buffer Outputs
logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0]					query_seq_buff;
logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0]					database_seq_buff;

// Matrix Calculation Outputs
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0]			scores_out_mat;
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][DATA_PACKET_SIZE-1:0]		data_packet_mat;

// Max Registers Outputs
logic [ROW_BITS_WIDTH-1:0]       							max_row;
logic [COL_BITS_WIDTH-1:0]       							max_col;

// Matrix Memory Outputs
logic [DATA_PACKET_SIZE-1:0]  								data_packet_out_memory;

/*===============================INSTANTIATION===============================*/

// Controller
	controller 	#(

				)

	I_controller
				(	
					// Clock & reset
					.clk(clk),
					.rst_n(rst_n),
					.ready(ready),
					.start(start),

					// Sequence Buffer
					.wr_en_buff(wr_en_buff),
					.count_buff(count_buff),

					// Matrix Calculation
					.top_sel(top_sel),
					.left_sel(left_sel),
					.diagonal_sel(diagonal_sel),
					.query_letter_sel(query_letter_sel),
					.database_letter_sel(database_letter_sel),
					.wr_en_pu(wr_en_pu),
					
					// Matrix Memory
					.write_ctl(write_ctl),
					.choose_diagonal(choose_diagonal),
					.choose_pu(choose_pu),
					.choose_pe(choose_pe),

					// Max Registers
					.wr_en_max(wr_en_max),
					.row_in(row_in),
					.col_in(col_in),

					// Traceback
					.en_traceback(en_traceback),
					.start_of_traceback(start_of_traceback),
					.next_row(next_row),
					.next_col(next_col),
					.finished(finished),
					
					// Output
					.output_valid(output_valid)
				);

// Sequence Buffer
	sequence_buffer 	#(

						) 
	I_sequence_buffer
						(
							// Clock & reset
							.clk(clk),
							.rst_n(rst_n),

							// Controller Interface
							.wr_en_buff(wr_en_buff),
							.count(count_buff),

							// Design Input
							.query_seq_in(query_seq_in),
							.database_seq_in(database_seq_in),
							
							// Matrix Calc Interface
							.query_seq_out(query_seq_buff),
							.database_seq_out(database_seq_buff)
						);

// Matrix Calculation
	matrix_calculation  #(

						)

	I_matrix_calculation

						(
							// Clock & Reset
							.clk(clk),
							.rst_n(rst_n),

							// Sequences Input 
							.query_seq(query_seq_buff),
							.database_seq(database_seq_buff),
							
							// Controller Selectors
							.top_sel(top_sel),
							.left_sel(left_sel),
							.diagonal_sel(diagonal_sel),
							.query_letter_sel(query_letter_sel),
							.database_letter_sel(database_letter_sel),
							.wr_en_pu(wr_en_pu),
							
							// Outputs to max_registers
							.scores_out(scores_out_mat),
							
							// Outputs to matrix_memory
							.data_packet(data_packet_mat)
						);

// Matrix Memory
	matrix_memory 	#(

					)
	I_matrix_memory

					( 
						// CLK & RESET
						.clk(clk),
						.rst_n(rst_n),

						// Controller Interface
						.write_ctl(write_ctl),
						.choose_diagonal(choose_diagonal),
						.choose_pu(choose_pu),
						.choose_pe(choose_pe),

						// Write Interface
						.data_packet_in(data_packet_mat),
						
						// Read Interface
						.data_packet_out(data_packet_out_memory)
					);

// Max Registers
	max_registers 	#(

					) 
	I_max_registers
					( 
						// CLK & RESET
						.clk(clk),
						.rst_n(rst_n),

						// Controller Interface
						.wr_en_max(wr_en_max),
						
						// Comparison Inputs
						.score_in(scores_out_mat),
						.row_in(row_in),
						.col_in(col_in),
						
						// Max Output
						.max_score(score),
						.max_row(max_row),
						.max_col(max_col)
					);

// Traceback
	traceback 	#(

				) 
	I_traceback
				(
					// CLK & RESET
					.clk(clk),
					.rst_n(rst_n),

					// Controller Interface
					.en_traceback(en_traceback),
					.start_of_traceback(start_of_traceback),
					.next_row(next_row),
					.next_col(next_col),
					.finished(finished),

					// Matrix Calculation Interface
					.max_row(max_row),
					.max_col(max_col),
					
					// Max Registers Interface
					.data_packet(data_packet_out_memory),
					
					// Sequence Buffer Interface
					.query_seq_rd(query_seq_buff),
					.database_seq_rd(database_seq_buff),
					
					// Design Output
					.query_seq_out(query_seq_out),
					.database_seq_out(database_seq_out)
				);

// Test Units
	inverter 	#(

				) 
	I_inverter
				(
					.inverter_in(inverter_in),
					.inverter_out(inverter_out)
				);

	flipflop 	#(

				) 
	I_flipflop
				(
					.clk(clk),
					.rst_n(rst_n),
					.flipflop_in(flipflop_in),
					.flipflop_out(flipflop_out)
				);

endmodule
