/*------------------------------------------------------------------------------
 * File          : matrix_calculation.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 27, 2023
 * Description   : Computes required calculations for the matrix filling
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"
module matrix_calculation
import design_variables::*;
/*==============================PARAMS===============================*/
#(
// Defined in design_variables package
)

/*==============================IN/OUT===============================*/
(
	// Clock & Reset
	input logic		clk,
	input logic     rst_n,
	
	// Sequences Input 
	input logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0]	query_seq,
	input logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0]	database_seq,
	
	// Controller Selectors
	input logic [NUM_PU-2:0][1:0]	top_sel,
	input logic [NUM_PU-2:0][1:0]	left_sel,
	input logic [NUM_PU-2:0][1:0]	diagonal_sel,
	input logic [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][SEQ_LENGTH_W-1:0]	 query_letter_sel,
	input logic [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][SEQ_LENGTH_W-1:0]	 database_letter_sel,
	input logic [4:0] global_counter,
	
	// Outputs to max_registers
	output logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0]		scores_out, // we have 'NUM_PU' units. each PU has NUM_ROWS_COLS^2 PEs.
																									// this output collects scores from all PEs that are part of all of 'NUM_PU' PUs.
	
	// Outputs to matrix_memory
	output logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][DATA_PACKET_SIZE-1:0]	data_packet // we have 'NUM_PU' units. each PU has NUM_ROWS_COLS^2 PEs.
																									// this output collects all small data packets from all PEs that are part of all of 'NUM_PU' PUs.
);

/*===============================SIGNALS=============================*/

// PU scores
logic [NUM_PU-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0]						pu_top_scores;
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][SCORE_WIDTH-1:0]						pu_left_scores;
logic [NUM_PU-1:0][SCORE_WIDTH-1:0]											pu_diagonal_scores;

// letters inserted into each PU
logic 	 [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][LETTER_WIDTH-1:0] 			pu_query_letters;
logic 	 [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][LETTER_WIDTH-1:0] 			pu_database_letters;

// data packet collected from PU
logic	 [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0]						zero_score_bits;
logic  	 [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SOURCE_WIDTH-1:0]	sources;

// scores current cycle
logic	 [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0]	scores_cur_cycle;

// Registers
logic	 [NUM_PU-1:0][SCORE_WIDTH-1:0]										scores_before_two_cycles; // Registers for 2 cycles before (holding diagonal scores only)

/*================================LOGIC==============================*/

//===== PU Muxes data selection =======//
always_comb begin
	// Query Letters select
	for (int i = 0; i < NUM_PU; i++) begin 
		for (int j = 0; j <= NUM_LETTERS_TO_CHOOSE-1; j++) begin
			pu_query_letters[i][j] = query_seq[query_letter_sel[i][j]];
		end
	end
	
	// Database Letters select
	for (int i = 0; i < NUM_PU; i++) begin 
		for (int j = 0; j <= NUM_LETTERS_TO_CHOOSE-1; j++) begin 
			pu_database_letters[i][j] = database_seq[database_letter_sel[i][j]];
		end
	end
	
	// PU top score select
	for (int i = 0; i < NUM_PU; i++) begin 
		if (i == (NUM_PU - 1)) begin
			pu_top_scores[i] = '0;
		end
		
		else begin
			case (top_sel[i])
				2'd0 : pu_top_scores[i] = '0;
				2'd1 : pu_top_scores[i] = {scores_out[i][1][1],scores_out[i][1][0]};
				2'd2 : pu_top_scores[i] = {scores_out[i+1][1][1],scores_out[i+1][1][0]};
				default: pu_top_scores[i] = '0; // will not get here
			endcase
		end
	end
	
	// PU left score select
	for (int i = 0; i < NUM_PU; i++) begin 
		if (i == 0) begin
			case (left_sel[i])
				2'd0 : pu_left_scores[i] = '0;
				2'd1 : pu_left_scores[i] = {scores_out[i][1][1],scores_out[i][0][1]};
				default: pu_left_scores[i] = '0; // will not get here
			endcase
		end
		
		else if (i == (NUM_PU - 1)) begin
			pu_left_scores[i] = {scores_out[i-1][1][1],scores_out[i-1][0][1]};
		end
		
		else begin
			case (left_sel[i])
				2'd0 : pu_left_scores[i] = {scores_out[i][1][1],scores_out[i][0][1]};
				2'd1 : pu_left_scores[i] = {scores_out[i-1][1][1],scores_out[i-1][0][1]};
				default: pu_left_scores[i] = '0; // will not get here
			endcase
		end
	end
	
	// PU diagonal score select
	for (int i = 0; i < NUM_PU; i++) begin 
		if (i == 0) begin
			case (diagonal_sel[i])
				2'd0 : pu_diagonal_scores[i] = '0;
				2'd1 : pu_diagonal_scores[i] = scores_before_two_cycles[i];
				2'd2 : pu_diagonal_scores[i] = scores_before_two_cycles[i+1];
				default: pu_diagonal_scores[i] = '0; // will not get here
			endcase
		end
		
		else if (i == (NUM_PU - 1)) begin
			pu_diagonal_scores[i] = '0;
		end
		
		else begin
			case (diagonal_sel[i])
				2'd0 : pu_diagonal_scores[i] = '0;
				2'd1 : pu_diagonal_scores[i] = scores_before_two_cycles[i];
				2'd2 : pu_diagonal_scores[i] = scores_before_two_cycles[i-1];
				2'd3 : pu_diagonal_scores[i] = scores_before_two_cycles[i+1];
				default: pu_diagonal_scores[i] = '0; // will not get here
			endcase
		end
	end
end

//========= output from PUs ===========//
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		data_packet <= '0;
		scores_out  <= '0;
	end
	
	else begin 
		// Data packet assignment
		for (int i = 0; i < NUM_PU; i++) begin 
			for (int j = 0; j <= NUM_ROWS_PE-1; j++) begin 
				for (int k = 0; k <= NUM_COLS_PE-1; k++) begin 
					data_packet[i][j][k] <= {zero_score_bits[i][j][k], sources[i][j][k]};
				end
			end
		end
		
		// Scores out assignment
		for (int i = 0; i < NUM_PU; i++) begin 
			for (int j = 0; j <= NUM_ROWS_PE-1; j++) begin 
				for (int k = 0; k <= NUM_COLS_PE-1; k++) begin
					if ((global_counter > 5'd0 && global_counter <= 5'd16 && i[4:0] < global_counter) ||
						(global_counter > 5'd16 && global_counter <= 5'd31 && i[5:0] < (6'd32-{1'b0, global_counter}))) begin
						scores_out[i][j][k] <= scores_cur_cycle[i][j][k];
					end
					else begin
						scores_out[i][j][k] <= '0;
					end
				end
			end
		end
	end
end

//======scores_before_two_cycles ======//
generate
	for (genvar i = 0; i < NUM_PU; i++) begin : scores_before_2_cycles
		always_ff @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				scores_before_two_cycles[i] <= '0;

			end
			
			else begin	
				scores_before_two_cycles[i] <= scores_out[i][1][1]; // Passing only the diagonal score from one cycle before to two cycles before
			end
		end
	end
endgenerate

/*===========================INSTANTIATION===========================*/
// Iterating and making all 'NUM_PU' PUs
generate
	for (genvar i = 0; i < NUM_PU; i++) begin : PU
		processing_unit
		#()
		pu_inst (
					// Input Scores from near PUs
					.prev_top_scores(pu_top_scores[i]),
					.prev_left_scores(pu_left_scores[i]),
					.prev_diagonal_scores(pu_diagonal_scores[i]),
					
					// Input Letters for PEs
					.query_letters(pu_query_letters[i]),
					.database_letters(pu_database_letters[i]),
					
					// Outputs
					.scores_out(scores_cur_cycle[i]),
					.zero_score_bits(zero_score_bits[i]),
					.sources(sources[i])
				);
	end
endgenerate

endmodule
