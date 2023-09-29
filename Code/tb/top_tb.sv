/*------------------------------------------------------------------------------
 * File          : top_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Sep 9, 2023
 * Description   : Top's Testbench
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module top_tb;
import design_variables::*;

// Clock and reset signals
logic clk;
logic rst_n;

// Inputs to the top module
logic [INPUT_WIDTH-1:0] query_seq_in;
logic [INPUT_WIDTH-1:0] database_seq_in;

// Outputs from the top module
logic [LETTER_WIDTH:0] query_seq_out;
logic [LETTER_WIDTH:0] database_seq_out;
logic [SCORE_WIDTH-1:0] score;
logic output_valid;

// Instantiate the top module with parameters and signals
top #(
) dut (
	.clk(clk),
	.rst_n(rst_n),
	.query_seq_in(query_seq_in),
	.database_seq_in(database_seq_in),
	.query_seq_out(query_seq_out),
	.database_seq_out(database_seq_out),
	.score(score),
	.output_valid(output_valid)
);

// Clock generation
always begin
	#5 clk = ~clk;
end

// Test stimulus
initial begin
	// query = TACGCATGACTACGCATGTCTACGCATGACTA
	// database = ACTACTACTACTACTACTACTACTACTACTAC
		
	clk = 1'b0;
	rst_n = 1'b0;
	@(negedge clk);
		
	rst_n = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b01110010;
	database_seq_in = 8'b00101100;
	@(negedge clk);
	
	query_seq_in = 8'b01100011;
	database_seq_in = 8'b11001011;
	@(negedge clk);
	
	query_seq_in = 8'b00101100;
	database_seq_in = 8'b10110010;
	@(negedge clk);
	
	query_seq_in = 8'b00110111;
	database_seq_in = 8'b00101100;
	@(negedge clk);
	
	query_seq_in = 8'b11100110;
	database_seq_in = 8'b11001011;
	@(negedge clk);
	
	query_seq_in = 8'b01110010;
	database_seq_in = 8'b10110010;
	@(negedge clk);
	
	query_seq_in = 8'b01100011;
	database_seq_in = 8'b00101100;
	@(negedge clk);
	
	query_seq_in = 8'b00101100;
	database_seq_in = 8'b11001011;
	@(negedge clk);
	
	query_seq_in = 8'd0;
	database_seq_in = 8'd0;

	#500;
	$finish;
end

endmodule
