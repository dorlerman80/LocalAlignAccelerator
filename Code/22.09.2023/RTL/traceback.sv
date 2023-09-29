/*------------------------------------------------------------------------------
 * File          : traceback.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 10, 2023
 * Description   : Traceback stage
 *------------------------------------------------------------------------------*/
`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module traceback
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
	input logic 								en_traceback,
	input logic 								start_of_traceback,
	output logic 	[SEQ_LENGTH_W-1:0]			next_row,
	output logic 	[SEQ_LENGTH_W-1:0]			next_col,
	output logic								finished,
	
	// Matrix Calculation Interface
	input logic 	[SEQ_LENGTH_W-1:0]		max_row,
	input logic 	[SEQ_LENGTH_W-1:0]		max_col,
	
	// Matrix Memory Interface
	input logic 	[DATA_PACKET_SIZE-1:0]				data_packet,
	
	// Sequence Buffer Interface
	input logic 	[SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] 	query_seq_rd,
	input logic 	[SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] 	database_seq_rd,
	
	// Design Output
	output logic	[LETTER_WIDTH:0]				query_seq_out,
	output logic	[LETTER_WIDTH:0]				database_seq_out
);


/*==============================SIGNALS==============================*/
// current letters to compare
logic [LETTER_WIDTH-1:0] cur_query_letter;
logic [LETTER_WIDTH-1:0] cur_database_letter;

// next row
logic [SEQ_LENGTH_W-1:0] 	cur_or_next_row;
logic [SEQ_LENGTH_W-1:0]	next_row_d;
logic [SEQ_LENGTH_W-1:0]	next_row_q;

// next col
logic [SEQ_LENGTH_W-1:0] 	cur_or_next_col;
logic [SEQ_LENGTH_W-1:0]	next_col_d;
logic [SEQ_LENGTH_W-1:0]	next_col_q;

// query letter output
logic [LETTER_WIDTH:0] query_letter_or_line;

// database letter output
logic [LETTER_WIDTH:0] database_letter_or_line;

/*===============================LOGIC===============================*/

//---------current letters to compare--------//
assign cur_query_letter = query_seq_rd[next_col];
assign cur_database_letter = database_seq_rd[next_row];

//----------------next row--------------//
assign cur_or_next_row  =  (data_packet[1:0] == LEFT) 	? next_row_q : next_row_q - 5'b1;
assign next_row_d		=  (start_of_traceback) 		? max_row	 : cur_or_next_row;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		next_row_q <= '0;
	end

	else begin
		if (en_traceback)
			next_row_q <= next_row_d;
	end
end

assign next_row = next_row_q;


//----------------next col--------------//
assign cur_or_next_col  =  (data_packet[1:0] == TOP) 	? next_col_q : next_col_q - 5'b1;
assign next_col_d		=  (start_of_traceback) 		? max_col	 : cur_or_next_col;

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		next_col_q <= '0;
	end
		
	else begin
		if (en_traceback)
			next_col_q <= next_col_d;
	end
end

assign next_col = next_col_q;

//-------------letters output-------------//

// query letter output
assign query_letter_or_line  	=  (data_packet[1:0] == TOP) ? LINE : {1'b0, cur_query_letter};
assign query_seq_out		 	=  (finished || start_of_traceback) ? START_END_SIGNAL : query_letter_or_line;


// database letter output
assign database_letter_or_line  =  (data_packet[1:0] == LEFT) ? LINE : {1'b0, cur_database_letter};
assign database_seq_out		    =  (finished || start_of_traceback) ? START_END_SIGNAL : database_letter_or_line;

//-------------Controller Interface-------------//
assign finished = (data_packet[DATA_PACKET_SIZE-1] && en_traceback && ~start_of_traceback);

endmodule
