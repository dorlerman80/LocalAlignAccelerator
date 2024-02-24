/*------------------------------------------------------------------------------
 * File          : matrix_calculation_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Jun 11, 2023
 * Description   : Matrix Calculation's Testbench
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module matrix_calculation_tb;
import design_variables::*;

// Signals
logic clk;
logic rst_n;
logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] query_seq;
logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0] database_seq;
logic [NUM_PU-2:0][1:0]	top_sel;
logic [NUM_PU-2:0][1:0]	left_sel;
logic [NUM_PU-2:0][1:0]	diagonal_sel;
logic [4:0] global_counter;
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][$clog2(SEQ_LENGTH)-1:0] query_letter_sel;
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][$clog2(SEQ_LENGTH)-1:0] database_letter_sel;
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][SCORE_WIDTH-1:0] scores_out;
logic [NUM_PU-1:0][NUM_ROWS_PE-1:0][NUM_COLS_PE-1:0][DATA_PACKET_SIZE-1:0] data_packet;

// Instantiate the DUT
matrix_calculation #(
) dut (
  .clk(clk),
  .rst_n(rst_n),
  .query_seq(query_seq),
  .database_seq(database_seq),
  .top_sel(top_sel),
  .left_sel(left_sel),
  .diagonal_sel(diagonal_sel),
  .global_counter(global_counter),
  .query_letter_sel(query_letter_sel),
  .database_letter_sel(database_letter_sel),
  .scores_out(scores_out),
  .data_packet(data_packet)
);

// Clock generation
always begin
	#5 clk = ~clk;
end

// Test stimulus
initial begin
	clk = 1'b0;
	rst_n = 1'b0;
	query_seq = 64'b1000110111001001001110001101110010010011100011011100100100111000; // ATCAGTACGCATCAGTACGCATCAGTACGCAT
	database_seq = 64'b0011100011100011100011100011100011100011100011100011100011100011; // CATCATCATCATCATCATCATCATCATCATCA
	top_sel = '0;
	left_sel = '0;
	diagonal_sel = '0;
	global_counter = 5'd0;
	query_letter_sel = '0;
	database_letter_sel = '0;
	
	@(posedge clk);
	@(negedge clk);
	
	rst_n = 1'b1;
	for (int i = 0; i < 31; i++) begin
		global_counter += 5'd1;
		for (int j = 0; j < NUM_PU; j++) begin
			
			//letters decision
			if (i < 16) begin
				query_letter_sel[j][0] = 2*j;
				query_letter_sel[j][1] = 2*j+1;
				database_letter_sel[j][0] = 2*(i - j);
				database_letter_sel[j][1] = 2*(i - j) + 1;
			end
			else begin
				query_letter_sel[j][0] = 2*(i + j) - 30;
				query_letter_sel[j][1] = 2*(i + j) - 30 + 1;
				database_letter_sel[j][0] = 31 - (2*j+1);
				database_letter_sel[j][1] = 31 - 2*j;
			end
			
			//scores selectors
			if (j < 15) begin
				if (i < 16) begin
					if (j == 0) begin
						if (i == 0) begin
							top_sel[j] = 2'd0;
						end
						else begin
							top_sel[j] = 2'd1;
						end
						left_sel[j] = 2'd0;
						diagonal_sel[j] = 2'd0;
					end
					else begin
						if (i == j) begin
							top_sel[j] = 2'd0;
							diagonal_sel[j] = 2'd0;
						end
						else begin
							top_sel[j] = 2'd1;
							diagonal_sel[j] = 2'd2;
						end
						left_sel[j] = 2'd1;
					end
				end
				else begin
					top_sel[j] = 2'd2;
					if (j == 0) begin
						left_sel[j] = 2'd1;
					end
					else begin
						left_sel[j] = 2'd0;
					end
					if (i == 16) begin
						diagonal_sel[j] = 2'd1;
					end
					else begin
						if (j == 0) begin
							diagonal_sel[j] = 2'd2;
						end
						else begin
							diagonal_sel[j] = 2'd3;
						end
					end
				end
			end
		end
		@(negedge clk);
	end
	#10
  // End the simulation
  $finish;
end

endmodule