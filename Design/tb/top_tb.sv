/*------------------------------------------------------------------------------
 * File          : top_tb2.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Sep 19, 2023
 * Description   : Top's Testbench
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module top_tb2;
import design_variables::*;

// Clock and reset signals
logic clk;
logic rst_n;
logic ready;
logic start;

// Inputs to the top module
logic [INPUT_WIDTH-1:0] query_seq_in;
logic [INPUT_WIDTH-1:0] database_seq_in;
logic inverter_in;
logic flipflop_in;

// Outputs from the top module
logic [LETTER_WIDTH:0] query_seq_out;
logic [LETTER_WIDTH:0] database_seq_out;
logic [SCORE_WIDTH-1:0] score;
logic output_valid;
logic inverter_out;
logic flipflop_out;

// Instantiate the top module with parameters and signals
top #(
) dut (
	.clk(clk),
	.rst_n(rst_n),
	.ready(ready),
	.start(start),
	.query_seq_in(query_seq_in),
	.database_seq_in(database_seq_in),
	.inverter_in(inverter_in),
	.flipflop_in(flipflop_in),
	.query_seq_out(query_seq_out),
	.database_seq_out(database_seq_out),
	.score(score),
	.output_valid(output_valid),
	.inverter_out(inverter_out),
	.flipflop_out(flipflop_out)
);

// Clock generation
always begin
	#5 clk = ~clk;
end

// Test stimulus
initial begin
	// query = ACTTCTAGTGATGTATACCGCCTTGACTTGCC
	// database = ATCAATCTACTACGTATTGTACCTGTAGTGCT
		
	clk = 1'b0;
	rst_n = 1'b0;
	start = 1'b0;
	inverter_in = 1'b0;
	flipflop_in = 1'b1;
	@(negedge clk);
		
	rst_n = 1'b1;
	@(negedge clk);
	@(negedge clk);
	
	start = 1'b1;
	@(negedge clk);
	
	start = 1'b0;
	query_seq_in = 8'b10101100; // TTCA
	database_seq_in = 8'b00111000; // ACTA
	@(negedge clk);
	
	query_seq_in = 8'b01001011; // GATC
	database_seq_in = 8'b10111000; // TCTA
	inverter_in = 1'b0;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b10000110; // TAGT
	database_seq_in = 8'b00101100; // ATCA
	inverter_in = 1'b1;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b10001001; // TATG
	database_seq_in = 8'b00100111; // ATGC
	inverter_in = 1'b0;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b01111100; // GCCA
	database_seq_in = 8'b10011010; // TGTT
	inverter_in = 1'b1;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b10101111; // TTCC
	database_seq_in = 8'b10111100; // TCCA
	@(negedge clk);
	
	query_seq_in = 8'b10110001; // TCAG
	database_seq_in = 8'b01001001; // GATG
	@(negedge clk);
	
	query_seq_in = 8'b11110110; // CCGT
	database_seq_in = 8'b10110110; // TCGT
	@(negedge clk);
	
	query_seq_in = 8'd0;
	database_seq_in = 8'd0;

	#500;

    	// query = AGTGTGGCAAACGACCATCATGGTTCCTTTCA - 0001100110010111000000110100111100101100100101101011111010101100
    	// database = GAATTCCAGGCCATAGGCGTCGCAAATTATGT - 0100001010111100010111110010000101110110110111000000101000100110

    	@(negedge clk);
	@(negedge clk);
	
	start = 1'b1;
	@(negedge clk);
	
	start = 1'b0;
	query_seq_in = 8'b01100100; 
	database_seq_in = 8'b10000001; 
	@(negedge clk);
	
	query_seq_in = 8'b11010110; 
	database_seq_in = 8'b00111110; 
	inverter_in = 1'b0;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b11000000; 
	database_seq_in = 8'b11110101; 
	inverter_in = 1'b1;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b11110001; 
	database_seq_in = 8'b01001000; 
	inverter_in = 1'b0;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b00111000; 
	database_seq_in = 8'b10011101; 
	inverter_in = 1'b1;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b10010110; 
	database_seq_in = 8'b00110111; 
	@(negedge clk);
	
	query_seq_in = 8'b10111110; 
	database_seq_in = 8'b10100000; 
	@(negedge clk);
	
	query_seq_in = 8'b00111010; 
	database_seq_in = 8'b10011000;
	@(negedge clk);
	
	query_seq_in = 8'd0;
	database_seq_in = 8'd0;

    	#500

    	// query = TTATCCTTTCCGGACCCTCACGCATCAACCAG - 1010001011111010101111010100111111101100110111001011000011110001
    	// database = GAGCCTAATTGGGGCCAGGCTGGCGTGTCTAG - 0100011111100000101001010101111100010111100101110110011011100001

    	@(negedge clk);
	@(negedge clk);
	
	start = 1'b1;
	@(negedge clk);
	
	start = 1'b0;
	query_seq_in = 8'b10001010; 
	database_seq_in = 8'b11010001; 
	@(negedge clk);
	
	query_seq_in = 8'b10101111; 
	database_seq_in = 8'b00001011; 
	inverter_in = 1'b0;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b01111110; 
	database_seq_in = 8'b01011010; 
	inverter_in = 1'b1;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b11110001; 
	database_seq_in = 8'b11110101; 
	inverter_in = 1'b0;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b00111011; 
	database_seq_in = 8'b11010100; 
	inverter_in = 1'b1;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b00110111; 
	database_seq_in = 8'b11010110; 
	@(negedge clk);
	
	query_seq_in = 8'b00001110; 
	database_seq_in = 8'b10011001; 
	@(negedge clk);
	
	query_seq_in = 8'b01001111; 
	database_seq_in = 8'b01001011;
	@(negedge clk);
	
	query_seq_in = 8'd0;
	database_seq_in = 8'd0;

    	#500

    	// query = TCTGTATTATGGCAAACGGAAGCCAAATGTCG - 1011100110001010001001011100000011010100000111110000001001101101
    	// database = CGATGCAGGTCATATTTTTCCTTTAGATGTCC - 1101001001110001011011001000101010101011111010100001001001101111

    	@(negedge clk);
	@(negedge clk);
	
	start = 1'b1;
	@(negedge clk);
	
	start = 1'b0;
	query_seq_in = 8'b01101110; 
	database_seq_in = 8'b10000111; 
	@(negedge clk);
	
	query_seq_in = 8'b10100010; 
	database_seq_in = 8'b01001101; 
	inverter_in = 1'b0;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b01011000; 
	database_seq_in = 8'b00111001; 
	inverter_in = 1'b1;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b00000011; 
	database_seq_in = 8'b10100010; 
	inverter_in = 1'b0;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b00010111; 
	database_seq_in = 8'b11101010; 
	inverter_in = 1'b1;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b11110100; 
	database_seq_in = 8'b10101011; 
	@(negedge clk);
	
	query_seq_in = 8'b10000000; 
	database_seq_in = 8'b10000100; 
	@(negedge clk);
	
	query_seq_in = 8'b01111001; 
	database_seq_in = 8'b11111001;
	@(negedge clk);
	
	query_seq_in = 8'd0;
	database_seq_in = 8'd0;

    	#500

    	// query = TACGGACATATTCCCCATCACATGACTGGAGG - 1000110101001100100010101111111100101100110010010011100101000101
    	// database = CAAATCGGTGTGTTTTGCCCCCCAAAAGGTAG - 1100000010110101100110011010101001111111111111000000000101100001

    	@(negedge clk);
	@(negedge clk);
	
	start = 1'b1;
	@(negedge clk);
	
	start = 1'b0;
	query_seq_in = 8'b01110010; 
	database_seq_in = 8'b00000011; 
	@(negedge clk);
	
	query_seq_in = 8'b00110001; 
	database_seq_in = 8'b01011110; 
	inverter_in = 1'b0;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b10100010; 
	database_seq_in = 8'b01100110; 
	inverter_in = 1'b1;
	flipflop_in = 1'b0;
	@(negedge clk);
	
	query_seq_in = 8'b11111111; 
	database_seq_in = 8'b10101010; 
	inverter_in = 1'b0;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b00111000; 
	database_seq_in = 8'b11111101; 
	inverter_in = 1'b1;
	flipflop_in = 1'b1;
	@(negedge clk);
	
	query_seq_in = 8'b01100011; 
	database_seq_in = 8'b00111111; 
	@(negedge clk);
	
	query_seq_in = 8'b01101100; 
	database_seq_in = 8'b01000000; 
	@(negedge clk);
	
	query_seq_in = 8'b01010001; 
	database_seq_in = 8'b01001001;
	@(negedge clk);
	
	query_seq_in = 8'd0;
	database_seq_in = 8'd0;

    	#500
	$finish;

end

endmodule
