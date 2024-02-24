/*------------------------------------------------------------------------------
 * File          : traceback.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 10, 2023
 * Description   : Traceback stage
 *------------------------------------------------------------------------------*/

`include "./design_variables.vh"

module traceback
import design_variables::*; 
#()

/*==============================IN/OUT===============================*/
(	
	input logic 									clk,
	input logic 									rst_n,
	
	// Controller Inputs
	input logic 									en_traceback,
	input logic 									start_of_traceback,
	
	// Matrix Calculation Inputs
	input logic [ROW_BITS_WIDTH-1:0]				max_row,
	input logic [COL_BITS_WIDTH-1:0]				max_col,
	
	// Matrix Memory Inputs
	input logic [DATA_PACKET_SIZE-1:0]				data_packet,
	
	// Sequence Buffer Inputs
	input logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] 	query_seq_rd,
	input logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] 	database_seq_rd,
	
	// Outputs
	output logic [ROW_BITS_WIDTH-1:0]				next_row,
	output logic [COL_BITS_WIDTH-1:0]				next_col,
	output logic									finished,
	output logic [LETTER_WIDTH:0]					query_seq_out,
	output logic [LETTER_WIDTH:0]					database_seq_out
);

/*==============================SIGNALS==============================*/
// Current letters to compare
logic [LETTER_WIDTH-1:0] 	cur_query_letter;
logic [LETTER_WIDTH-1:0] 	cur_database_letter;

// Next row
logic [SEQ_LENGTH_W-1:0] 	cur_or_next_row;
logic [SEQ_LENGTH_W-1:0]	next_row_d;
logic [SEQ_LENGTH_W-1:0]	next_row_q;

// Next column
logic [SEQ_LENGTH_W-1:0] 	cur_or_next_col;
logic [SEQ_LENGTH_W-1:0]	next_col_d;
logic [SEQ_LENGTH_W-1:0]	next_col_q;

// Query letter output
logic [LETTER_WIDTH:0] 		query_letter_or_line;

// Database letter output
logic [LETTER_WIDTH:0] 		database_letter_or_line;

// Indication for row or column zero
logic				 		first_row_or_col;
logic 						row_or_col_zero;

/*===============================LOGIC===============================*/
// Current letters to compare
assign cur_query_letter = query_seq_rd[next_col];
assign cur_database_letter = database_seq_rd[next_row];

// Next row
assign cur_or_next_row = (data_packet[1:0] == LEFT) ? next_row_q : (next_row_q - 5'b1);
assign next_row_d = (start_of_traceback) ? max_row : cur_or_next_row;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		next_row_q <= '0;
	end

	else begin
		if (en_traceback)
			next_row_q <= next_row_d;
	end
end

// Next column
assign cur_or_next_col = (data_packet[1:0] == TOP) ? next_col_q : next_col_q - 5'b1;
assign next_col_d = (start_of_traceback) ? max_col : cur_or_next_col;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		next_col_q <= '0;
	end
		
	else begin
		if (en_traceback)
			next_col_q <= next_col_d;
	end
end

// Indication for first row or column
assign row_or_col_zero = (~|next_row || ~|next_col) && en_traceback && ~start_of_traceback;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		first_row_or_col <= '0;
	end
		
	else begin
		if (row_or_col_zero)
			first_row_or_col <= 1'b1;
		else if (finished)
			first_row_or_col <= 1'b0;
	end
end

// Letters outputs
assign query_letter_or_line = (data_packet[1:0] == TOP) ? LINE : {1'b0, cur_query_letter};
assign query_seq_out = (finished || start_of_traceback) ? START_END_SIGNAL : query_letter_or_line;

assign database_letter_or_line = (data_packet[1:0] == LEFT) ? LINE : {1'b0, cur_database_letter};
assign database_seq_out = (finished || start_of_traceback) ? START_END_SIGNAL : database_letter_or_line;

// Controller Outputs
assign next_row = next_row_q;
assign next_col = next_col_q;
assign finished = ((data_packet[DATA_PACKET_SIZE-1] || first_row_or_col) && en_traceback && ~start_of_traceback);

endmodule
