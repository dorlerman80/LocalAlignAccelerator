class sw_ref_model extends uvm_component;
	
	`uvm_component_param_utils(ref_model)

	// Parameters for the algorithm
	int unsigned MATCH_SCORE = design_variables::MATCH;
	int unsigned MISMATCH_SCORE = design_variables::MISMATCH;
	int unsigned GAP_PENALTY = design_variables::GAP_PENALTY;
	int unsigned SEQ_LENGTH = design_variables::SEQ_LENGTH;
	
	int debug_level = 2; // Debug level (0: none, 1: standard, 2: detailed)

	// Encoding for inputs and outputs (based on tables)
	typedef enum bit [1:0] {A = 2'b00, G = 2'b01, T = 2'b10, C = 2'b11} input_encoding_t;
	typedef enum bit [2:0] {OUT_A = 3'b000, OUT_G = 3'b001, OUT_T = 3'b010, OUT_C = 3'b011, GAP = 3'b100, START_END = 3'b111} output_encoding_t;


	function new(string name = "ref_model", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM)
	endfunction : new
	

	// Task to compute the Smith-Waterman score and aligned sequences
	task compute_alignment(bit [7:0] qry[8], bit [7:0] db[8], output int unsigned max_score, output bit [2:0] aligned_qry[$], output bit [2:0] aligned_db[$]);
		int unsigned score_matrix[][]; // Declare as a dynamic array
		int unsigned len_qry = SEQ_LENGTH;  // Use $size to get the size of qry
		int unsigned len_db = SEQ_LENGTH;  // Use $size to get the siz`e of db
		int unsigned i, j;
		int unsigned max_row, max_col;
		int unsigned score_diagonal, score_up, score_left;
		int unsigned qry_letter, db_letter;
		
		if (debug_level >= 1) begin
			$display("Length of query (len_qry): %0d", len_qry);
			$display("Length of database (len_db): %0d", len_db);
		end

		// Initialize score matrix
		score_matrix = new[len_qry + 1]; // Allocate rows
		foreach (score_matrix[i]) begin
			score_matrix[i] = new[len_db + 1]; // Allocate columns for each row
		end
		initialize_matrix(score_matrix, len_qry, len_db);
		
		
		if (debug_level >= 1) begin
			$display("Score matrix initialized to size [%0d][%0d]", len_qry+1, len_db+1);
			for (i = 0; i <= len_db; i++) begin
				for (j = 0; j <= len_qry; j++) begin
					$write("%0d ", score_matrix[i][j]);
				end
				$display("");
			end
		end

		// Initialize max_score
		max_score = 0;

		// Fill the score matrix
		for (i = 1; i <= len_db; i++) begin
			for (j = 1; j <= len_qry; j++) begin
				
				qry_letter = qry[(i-1)/4][((i-1)%4)*2 +: 2];
				db_letter = db[(j-1)/4][((j-1)%4)*2 +: 2];

				// Compute scores for diagonal, up, and left
				score_diagonal = score_matrix[i-1][j-1] + (qry_letter == db_letter ? MATCH_SCORE : -MISMATCH_SCORE);
				score_up = max(score_matrix[i-1][j] - GAP_PENALTY, 0);
				score_left = max(score_matrix[i][j-1] - GAP_PENALTY, 0);

				score_matrix[i][j] = max(score_diagonal, max(score_up, max(score_left, 0)));

				if (score_matrix[i][j] > max_score) begin
					max_score = score_matrix[i][j];
					max_row = i;
					max_col = j;
				end
				
				if (debug_level >= 2) begin
					$display("Filling score_matrix[%0d][%0d]: diag=%0d, up=%0d, left=%0d -> max=%0d",
							 i, j, score_diagonal, score_up, score_left, score_matrix[i][j]);
				end
			end
		end
		
		if (debug_level >= 1) begin
			$display("Score matrix after filling:");
			for (i = 0; i <= len_qry; i++) begin
				for (j = 0; j <= len_db; j++) begin
					$write("%0d ", score_matrix[i][j]);
				end
				$display("");
			end
		end
		
		// Print max_row and max_col after filling the score matrix
		if (debug_level >= 1) begin
			$display("Max score found at row: %0d, column: %0d with score: %0d", max_row, max_col, max_score);
		end
		
		// Perform traceback to get the aligned sequences
		traceback(score_matrix, qry, db, aligned_qry, aligned_db, max_row, max_col);
	endtask

	// Function to initialize the score matrix
	function void initialize_matrix(ref int unsigned matrix[][], int unsigned len_qry, int unsigned len_db);
		for (int i = 0; i <= len_db; i++) begin
			for (int j = 0; j <= len_qry; j++) begin
				matrix[i][j] = (i == 0 || j == 0) ? 0 : 'x; // Initialize first row and column to 0
			end
		end
	endfunction

	// Helper function to calculate max
	function int max(input int a, b);
		return (a > b) ? a : b;
	endfunction

	// Function to perform traceback and get the aligned sequences
	function void traceback(ref int unsigned matrix[][], bit [7:0] qry[8], bit [7:0] db[8], 	
							ref bit [2:0] aligned_qry[$], ref bit [2:0] aligned_db[$], 
							int unsigned max_row, int unsigned max_col);
		int i = max_row;  // Use $size
		int j = max_col;  // Use $size
		int idx = 0;
		
		int unsigned qry_letter, db_letter;

		// Start signal
		aligned_qry[idx] = START_END;
		aligned_db[idx] = START_END;
		idx++;

		// Perform traceback until reaching the top or left of the matrix
		while (i > 0 && j > 0) begin
			if (debug_level >= 1) begin
				$display("At i = %0d, j = %0d", i, j);
			end
			
			if (matrix[i][j] == 0) break;
			
			// Decode 2-bit letters
			qry_letter = qry[(i-1)/4][((i-1)%4)*2 +: 2];
			db_letter = db[(j-1)/4][((j-1)%4)*2 +: 2];

			// Match/mismatch
			if (matrix[i][j] == matrix[i-1][j-1] + ((qry_letter == db_letter) ? MATCH_SCORE : -MISMATCH_SCORE)) begin
				aligned_qry[idx] = encode_output(qry[i-1]);
				aligned_db[idx] = encode_output(db[j-1]);
				i--;
				j--;
			end
			// Gap in qry
			else if (matrix[i][j] == matrix[i-1][j] + GAP_PENALTY) begin
				aligned_qry[idx] = GAP;
				aligned_db[idx] = GAP;
				i--;
			end
			// Gap in db
			else if (matrix[i][j] == matrix[i][j-1] + GAP_PENALTY) begin
				aligned_qry[idx] = GAP;
				aligned_db[idx] = GAP;
				j--;
			end
			idx++;
		end
		
		if (debug_level >= 1) begin
			$display("Aligned Query Sequence:");
			foreach (aligned_qry[i]) begin
				if (aligned_qry[i] != START_END)  // Check if it's not the start/end signal
					$display("%b", aligned_qry[i]);
			end

			$display("Aligned Database Sequence:");
			foreach (aligned_db[i]) begin
				if (aligned_db[i] != START_END)  // Check if it's not the start/end signal
					$display("%b", aligned_db[i]);
			end
		end

		// End signal
		aligned_qry[idx] = START_END;
		aligned_db[idx] = START_END;
	endfunction

	// Function to encode output values based on input encoding
	function bit [2:0] encode_output(bit [1:0] input_letter);
		case (input_letter)
			A: return OUT_A;
			G: return OUT_G;
			T: return OUT_T;
			C: return OUT_C;
			default: return 3'bxxx; // Undefined input
		endcase
	endfunction

endclass


//// TESTBENCH
//module tb_smith_waterman;
//// Define encoding values directly in the testbench
//typedef enum bit [1:0] {A = 2'b00, G = 2'b01, T = 2'b10, C = 2'b11} input_encoding_t;
//typedef enum bit [2:0] {OUT_A = 3'b000, OUT_G = 3'b001, OUT_T = 3'b010, OUT_C = 3'b011, GAP = 3'b100, START_END = 3'b111} output_encoding_t;
//
//// Function to convert the encoded values to nucleotides or gap
//function [8*1:0] decode_output(bit [2:0] output_letter);
//	case (output_letter)
//		OUT_A: decode_output = "A";
//		OUT_G: decode_output = "G";
//		OUT_T: decode_output = "T";
//		OUT_C: decode_output = "C";
//		START_END: decode_output = "^";
//		GAP: decode_output = "-";
//		default: decode_output = "?"; // Undefined input
//	endcase
//endfunction
//
//initial begin
//	// Create an instance of the Smith-Waterman model
//	ref_model sw = new();
//
//	// Example sequences as 8-bit arrays (each element holds 4 letters encoded in 2 bits each)
//	bit [7:0] qry[8] = { {A, T, C, G},
//						 {T, A, G, C},
//						 {C, G, T, A},
//						 {A, T, G, C},
//						 {T, C, G, A},
//						 {A, T, C, G},
//						 {G, C, T, A},
//						 {A, T, C, G} };
//
//	bit [7:0] db[8] = { {A, T, C, G},
//			{T, A, G, C},
//			{C, G, T, A},
//			{A, T, G, C},
//			{T, C, G, A},
//			{A, T, C, G},
//			{G, C, T, A},
//			{A, T, C, G} };
//	
////	{T, G, C, A},
////			{G, T, A, C},
////			{T, A, G, C},
////			{C, G, T, A},
////			{T, C, G, A},
////			{A, T, G, C},
////			{G, C, T, A},
////			{A, T, C, G}
//	
//
//	// Variables to store the maximum score and aligned sequences
//	int unsigned max_score;
//	bit [2:0] aligned_qry[$];
//	bit [2:0] aligned_db[$];
//
//	// Compute the alignment and score
//	sw.compute_alignment(qry, db, max_score, aligned_qry, aligned_db);
//
//	// Print the result
//	$display("\033[31mMaximum Score: %0d\033[0m", max_score); 
//
//	// Print aligned query
//	$display("\033[31mAligned Query: \033[0m");
//	for (int i = 0; i < aligned_qry.size(); i = i + 1) begin
//		$write("\033[32m%s\033[0m", decode_output(aligned_qry[i]));  // Convert to letter and print in green
//	end
//	$display(""); // New line for the aligned query
//
//	// Print aligned database
//	$display("\033[31mAligned Database: \033[0m");
//	for (int i = 0; i < aligned_db.size(); i = i + 1) begin
//		$write("\033[32m%s\033[0m", decode_output(aligned_db[i]));  // Convert to letter and print in green
//	end
//	$display(""); // New line for the aligned database
//end
//endmodule
