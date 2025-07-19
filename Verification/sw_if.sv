interface sw_if();

    // Clock & reset
	logic		  clk;
	logic         rst_n;
	
	// Inputs
	logic							        					start;
	logic  [design_variables::INPUT_WIDTH-1:0]              	query_seq_in;
	logic  [design_variables::INPUT_WIDTH-1:0]              	database_seq_in;
	logic														inverter_in;
	logic														flipflop_in;
	
	// Outputs
	logic														ready;
	logic [design_variables::LETTER_WIDTH:0]					query_seq_out;
	logic [design_variables::LETTER_WIDTH:0]					database_seq_out;
	logic [design_variables::SCORE_WIDTH-1:0]					score;
	logic														output_valid;
	logic														inverter_out;
	logic														flipflop_out;
	
endinterface