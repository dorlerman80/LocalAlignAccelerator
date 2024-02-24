/*------------------------------------------------------------------------------
 * File          : controller.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Aug 18, 2023
 * Description   : Controller's Logic
 *------------------------------------------------------------------------------*/

`include "./design_variables.vh"

module controller
import design_variables::*;
#()
(
/*==============================IN/OUT===============================*/
	// Clock & reset
	input logic		clk,
	input logic     rst_n,
	input logic		start,
	
	// Sequence Buffer
	output logic                       				wr_en_buff,
	output logic [BUFF_CNT_W-1:0]     				count_buff,
	
	// Matrix Calculation
	output logic [NUM_PU-2:0][SLCT_VAL_PE_TOP-1:0]									top_sel,															
	output logic [NUM_PU-2:0][SLCT_VAL_PE_LEFT-1:0]									left_sel,													
	output logic [NUM_PU-2:0][SLCT_VAL_PE_DIAGONAL-1:0]								diagonal_sel,
	output logic [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][SEQ_LENGTH_W-1:0]			query_letter_sel,
	output logic [NUM_PU-1:0][NUM_LETTERS_TO_CHOOSE-1:0][SEQ_LENGTH_W-1:0]			database_letter_sel,
	output logic [NUM_PU-1:0] 														wr_en_pu,

	// Max Registers
	output logic  wr_en_max,
	output logic  [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][ROW_BITS_WIDTH-1:0]     row_in,					 
	output logic  [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][COL_BITS_WIDTH-1:0]     col_in,
		
	// Matrix Memory
	output logic [NUM_DIAGONALS-1:0]		   write_ctl,
	output logic [NUM_DIAGONALS_W-1:0] 		   choose_diagonal,
	output logic [NUM_PU_MAIN_DIAGONAL_W-1:0]  choose_pu,
	output logic [NUM_PE_IN_PU_W-1:0]		   choose_pe,
	
	// Traceback
	output logic 							en_traceback,
	output logic 							start_of_traceback,
	input  logic 	[ROW_BITS_WIDTH-1:0]	next_row,
	input  logic 	[COL_BITS_WIDTH-1:0]	next_col,
	input  logic							finished,
	
	// Output
	output logic							output_valid,
	output logic							ready
);

/*==========================INTERNAL SIGNALS=========================*/
// FSM
typedef enum bit [1:0] {IDLE_ST = 2'b00, LOAD_SEQUENCES_ST = 2'b01, SCORES_CALC_ST = 2'b10, TRACEBACK_ST = 2'b11} STATE;
STATE CUR_ST;
STATE NEXT_ST;

// global counter
logic [4:0] global_counter;
logic busy;

// Matrix memory
logic [NUM_DIAGONALS-1:0] write_ctl_reg;
logic [ROW_BITS_WIDTH:0] row_col_sum;

// Traceback
logic prev_en_traceback;


/*===========================GLOBAL COUNTER==========================*/
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		global_counter <= '0;
	end	 
	else if (busy) begin
			global_counter <= global_counter + 5'd1;
	end
	else if (finished) begin
		global_counter <= '0;
	end
end

/*==============================FSM LOGIC============================*/
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		CUR_ST <= IDLE_ST;
	end
	else begin
		CUR_ST <= NEXT_ST;
	end
end

always_comb begin
	// Default values
	ready = 1'b0;
	wr_en_buff = 1'b0;
	count_buff = '0;
	wr_en_max = 1'b0;
	en_traceback = 1'b0;
	output_valid = 1'b0;
	busy = 1'b1;
	NEXT_ST = CUR_ST;
	
	case (CUR_ST)
		IDLE_ST:
		begin
			ready = 1'b1;
			busy = 1'b0;
			if (start == 1'b1) begin
				NEXT_ST = LOAD_SEQUENCES_ST;
			end
		end

		LOAD_SEQUENCES_ST:
		begin
			wr_en_buff = 1'b1;
			count_buff = global_counter[2:0];
			
			if (global_counter > 5'd1) begin
				wr_en_max = 1'b1;
			end
			
			if (global_counter == 5'd7) begin
				NEXT_ST = SCORES_CALC_ST;
			end
		end
			
		SCORES_CALC_ST:
		begin
			wr_en_max = 1'b1;
			
			if (global_counter == 5'd00) begin
				NEXT_ST = TRACEBACK_ST;
			end
		end
		
		TRACEBACK_ST:
		begin
			en_traceback = 1'b1;
			output_valid = 1'b1;
			busy = 1'b0;
			if (finished) begin
				NEXT_ST = IDLE_ST;
			end
		end
	endcase
end

/*===========================MATRIX CALCULATION==========================*/

// PUs Write Enable
always_comb begin		
	for (int unsigned i = 0; i < NUM_PU; i++) begin 
		if (((global_counter > 5'd0 && global_counter <= 5'd16) && i[4:0] < global_counter) ||
			((global_counter > 5'd16 && global_counter <= 5'd31) && (i[5:0] < (6'd32-{1'b0, global_counter})))) begin
			wr_en_pu[i] = 1'b1;
		end
		else begin
			wr_en_pu[i] = 1'b0;
		end
	end
end

// Query letters select
always_comb begin
	for (int unsigned j = 0; j < NUM_PU; j++) begin
		if (global_counter <= 5'd16) begin // upper half
			query_letter_sel[j][0] = 5'd2*j[4:0]; // 2j
			query_letter_sel[j][1] = 5'd2*j[4:0] + 5'd1; // 2j+1
		end
		else begin // lower half
			query_letter_sel[j][0] = 5'd2*(global_counter - 5'd1 + j[4:0]) - 5'd30; // 2(global_counter + j) - 30
			query_letter_sel[j][1] = 5'd2*(global_counter - 5'd1 + j[4:0]) - 5'd30 + 5'd1; // 2(global_counter + j) - 30 + 1
		end
	end
end

// Database letters select
always_comb begin
	for (int unsigned j = 0; j < NUM_PU; j++) begin
		if(global_counter <= 5'd16) begin // upper half
			database_letter_sel[j][0] = 5'd2*(global_counter - 5'd1 - j[4:0]); // 2(global_counter - j)
			database_letter_sel[j][1] = 5'd2*(global_counter - 5'd1 - j[4:0]) + 5'd1; // 2(global_counter - j) + 1
		end
		else begin // lower half
			database_letter_sel[j][0] = 5'd31 - (5'd2*j[4:0]+5'd1); // 31 - (2j + 1)
			database_letter_sel[j][1] = 5'd31 - 5'd2*j[4:0]; // 31 - 2j
		end
	end	
end

// Top select
always_comb begin
	for (int unsigned j = 0; j < $unsigned(NUM_PU - 1); j++) begin
		if (global_counter <= 5'd16) begin // upper half
			if (j == 0) begin // PU number 0 (On the first column)
				top_sel[j] = (global_counter == 5'd1) ? 2'd0 : 2'd1;
			end

			else if(j[4:0] == global_counter - 5'd1) begin // PUs on the first row
				top_sel[j] = 2'd0;
			end
			
			else begin
				top_sel[j] = 2'd1;
			end
		end

		else begin // lower half
			top_sel[j] = 2'd2; 
		end
	end
end

// Left select
always_comb begin
	for (int j = 0; j < NUM_PU - 1; j++) begin
		if (global_counter <= 5'd16) begin // upper half
			if (j == 0) begin // PU number 0
				left_sel[j] = 2'd0;
			end

			else begin
				left_sel[j] = 2'd1;
			end
		end

		else begin // lower half
			if (j == 0) begin // Pu number 0 
				left_sel[j] = 2'd1;
			end

			else begin
				left_sel[j] = 2'd0;
			end
		end
	end	
end

// Diagonal select
always_comb begin
	for (int unsigned j = 0; j < $unsigned(NUM_PU - 1); j++) begin
		if (global_counter < 5'd17) begin // upper half
			if(j == 0) begin // PU number 0 
				diagonal_sel[j] = 2'd0;
			end

			else if (j[4:0] == global_counter - 5'b1) begin // PUs on the first row
				diagonal_sel[j] = 2'd0;
			end
			
			else begin // lower half
				diagonal_sel[j] = 2'd2;
			end
		end

		else begin
			if (global_counter == 5'd17) begin // main diagonal
				diagonal_sel[j] = 2'd1;
			end
			else begin
				if (j == 0) begin // Pu number 0
					diagonal_sel[j] = 2'd2;
				end
				else begin
					diagonal_sel[j] = 2'd3;
				end
			end
		end
	end	
end

/*==============================MATRIX MEMORY============================*/
//========= Memory Write =========//
always_ff @(posedge clk or negedge rst_n) begin

	if (!rst_n) begin
		write_ctl_reg <= '0;
	end
	
	else if (/*global_counter <= 5'd31 &&*/ global_counter > 5'd0 && busy) begin
		if (global_counter == 5'd1) begin
			write_ctl_reg <= {{NUM_DIAGONALS-1{1'b0}}, 1'b1};
		end
		
		else begin
			write_ctl_reg <= (write_ctl_reg << 1);
		end
	end
	
	else begin
		write_ctl_reg <= '0;
	end
end

assign write_ctl = write_ctl_reg;


//========= Memory Read =========//

// Choose PE
// O = Odd , E = Even
// -------------------
// | (E,E)  |  (E,O) |
// |--------|--------|
// | (O,E)  |  (O,O) |
// -------------------

always_comb begin
	choose_pe = 2'b00;
	
	if(next_row[0] == 1'b1 & next_col[0] == 1'b1) begin // bottom right PE
		choose_pe = 2'b11;
	end
	
	else if(next_row[0] == 1'b0 & next_col[0] == 1'b0) begin // top left PE
		choose_pe = 2'b00;
	end
	
	else if(next_row[0] == 1'b0 & next_col[0] == 1'b1) begin // top right PE
		choose_pe = 2'b01;
	end
	
	else if(next_row[0] == 1'b1 & next_col[0] == 1'b0) begin // bottom left PE
		choose_pe = 2'b10;
	end
end

// Choose Diagonal
assign choose_diagonal = (next_row >> 1) + (next_col >> 1);

// Choose PU
assign row_col_sum = {1'b0, next_row} + {1'b0, next_col};
assign choose_pu = (row_col_sum[COL_BITS_WIDTH]) ? ~next_row[COL_BITS_WIDTH-1:1] : next_col[COL_BITS_WIDTH-1:1];

/*=============================Max Registers=============================*/

// Row_in
always_comb begin
	row_in = '0;
	for (int unsigned i = 0; i < COMPARE_UNITS_LVL_1; i++) begin 
		for (int j = 0; j < NUM_VALS_LVL_1 - 1; j++) begin
			if (wr_en_max) begin
				if (global_counter >= 5'd2 && global_counter <= 5'd17) begin // upper half
					row_in[i][0] = (global_counter - 5'd2 - i[4:0]) * 5'd2;
					row_in[i][1] = (global_counter - 5'd2 - i[4:0]) * 5'd2;
					row_in[i][2] = (global_counter - 5'd2 - i[4:0]) * 5'd2 + 5'd1;
					row_in[i][3] = (global_counter - 5'd2 - i[4:0]) * 5'd2 + 5'd1;
				end
				else begin // lower half
					row_in[i][0] = 5'd30 - 5'd2*i[4:0];
					row_in[i][1] = 5'd30 - 5'd2*i[4:0];
					row_in[i][2] = 5'd30 - 5'd2*i[4:0] + 5'd1;
					row_in[i][3] = 5'd30 - 5'd2*i[4:0] + 5'd1;
				end
			end
		end
	end
end


// Col_in
always_comb begin
	col_in = '0;
	for (int unsigned i = 0; i < COMPARE_UNITS_LVL_1; i++) begin 
		for (int j = 0; j < NUM_VALS_LVL_1 - 1; j++) begin
			if (wr_en_max) begin
				if (global_counter >= 5'd2 && global_counter <= 5'd17) begin // upper half
					col_in[i][0] = 5'd2*i[4:0];
					col_in[i][1] = 5'd2*i[4:0] + 5'd1;
					col_in[i][2] = 5'd2*i[4:0];
					col_in[i][3] = 5'd2*i[4:0] + 5'd1;
				end
				else begin // lower half
					col_in[i][0] = (global_counter - 5'd17 + i[4:0]) * 5'd2;
					col_in[i][1] = (global_counter - 5'd17 + i[4:0]) * 5'd2 + 5'd1;
					col_in[i][2] = (global_counter - 5'd17 + i[4:0]) * 5'd2;
					col_in[i][3] = (global_counter - 5'd17 + i[4:0]) * 5'd2 + 5'd1;
				end
			end
		end
	end
end

/*===============================TRACEBACK===============================*/
always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		prev_en_traceback <= '0;
	end
	
	else begin
		prev_en_traceback <= en_traceback;
	end		
end

assign start_of_traceback = ~prev_en_traceback && en_traceback;

endmodule

