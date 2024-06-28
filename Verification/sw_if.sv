interface sw_if();

    // Clock & reset
	logic		  clk;
	logic         rst_n;
	
	// Inputs
	logic							        start;
	logic  [INPUT_WIDTH-1:0]              	query_seq_in;
	logic  [INPUT_WIDTH-1:0]              	database_seq_in;
	logic									inverter_in;
	logic									flipflop_in;
	
	// Outputs
	logic									ready;
	logic [LETTER_WIDTH:0]					query_seq_out;
	logic [LETTER_WIDTH:0]					database_seq_out;
	logic [SCORE_WIDTH-1:0]					score;
	logic									output_valid;
	logic									inverter_out;
	logic									flipflop_out;

endinterface