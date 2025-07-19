class sw_ref_model extends uvm_component;
	
	`uvm_component_param_utils(sw_ref_model)
	
	// Declare Analysis Imps and FIFOs
	`uvm_analysis_imp_decl(_sw_qry_in)
	`uvm_analysis_imp_decl(_sw_db_in)
	
	// Analysis exports
	uvm_analysis_imp_sw_qry_in #(seq_t, sw_ref_model) sw_qry_in_analysis_export;
	uvm_analysis_imp_sw_db_in #(seq_t, sw_ref_model) sw_db_in_analysis_export;
	
	// FIFOs to store sequences from analysis exports
	uvm_tlm_analysis_fifo #(seq_t) sw_qry_in_fifo;  // FIFO for sw query data
	uvm_tlm_analysis_fifo #(seq_t) sw_db_in_fifo;   // FIFO for sw database data
	
	// Analysis ports
	uvm_analysis_port#(out_seq_t) sw_qry_out_analysis_port;
	uvm_analysis_port#(out_seq_t) sw_db_out_analysis_port;
	uvm_analysis_port#(int unsigned) sw_score_analysis_port;
	
	
	seq_t sw_qry_in;
	seq_t sw_db_in;
	
	out_seq_t sw_qry_out;
	out_seq_t sw_db_out;
	
	int unsigned max_score;
	bit [2:0] aligned_qry[$];
	bit [2:0] aligned_db[$];

	
	// Parameters for the algorithm
	int unsigned MATCH_SCORE = design_variables::MATCH;
	int unsigned MISMATCH_SCORE = design_variables::MISMATCH;
	int unsigned GAP_PENALTY = design_variables::GAP_PENALTY;
	int unsigned SEQ_LENGTH = design_variables::SEQ_LENGTH;
	
	int debug_level = 0; // Debug level (0: none, 1: standard, 2: detailed)

	// Encoding for inputs and outputs (based on tables)
	typedef enum bit [1:0] {A = 2'b00, G = 2'b01, T = 2'b10, C = 2'b11} input_encoding_t;
	typedef enum bit [2:0] {OUT_A = 3'b000, OUT_G = 3'b001, OUT_T = 3'b010, OUT_C = 3'b011, GAP = 3'b100, START_END = 3'b111} output_encoding_t;


	function new(string name = "sw_ref_model", uvm_component parent = null);
		super.new(name, parent);
		
		// Initialize analysis exports
		sw_qry_in_analysis_export = new("sw_qry_in_analysis_export", this);
		sw_db_in_analysis_export = new("sw_db_in_analysis_export", this);
		
		// Initialize FIFOs
		sw_qry_in_fifo = new("sw_qry_in_fifo", this);
		sw_db_in_fifo = new("sw_db_in_fifo", this);
		
		sw_qry_out_analysis_port = new("sw_qry_out_analysis_port", this);
		sw_db_out_analysis_port = new("sw_db_out_analysis_port", this);
		sw_score_analysis_port = new("sw_score_analysis_port", this);
		
		
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH)
	endfunction : new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
	endfunction

	
	// Write methods for analysis exports
	virtual function void write_sw_qry_in(seq_t qry_in);
	  sw_qry_in_fifo.write(qry_in); // Write to FIFO
	  `uvm_info("WRITE_SW_QRY_IN", $sformatf("Packet written to sw_qry_in_fifo: %p", qry_in), UVM_HIGH);
	endfunction
	
	
	// Write methods for analysis exports
	virtual function void write_sw_db_in(seq_t db_in);
	  sw_db_in_fifo.write(db_in); // Write to FIFO
	  `uvm_info("WRITE_SW_DB_IN", $sformatf("Packet written to sw_db_in_fifo: %p", db_in), UVM_HIGH);
	endfunction
	
	
	virtual task perform_sw_algorithm();
		fork begin
			forever begin
				sw_qry_in_fifo.get(sw_qry_in); // Blocking call: waits until data is available
				sw_db_in_fifo.get(sw_db_in);   // Blocking call: waits until data is available
				
				
				compute_alignment(sw_qry_in, sw_db_in, max_score, aligned_qry, aligned_db);
				
				if (debug_level >= 1) begin
					$display("Aligned Query Sequence after performing Alignment:");
					foreach (aligned_qry[i]) begin
						if (aligned_qry[i] != START_END)  // Check if it's not the start/end signal
							$write("\033[32m%s\033[0m", decode_output(aligned_qry[i]));
					end
					
					$display("");

					$display("Aligned DB Sequence after performing Alignment:");
					foreach (aligned_db[i]) begin
						if (aligned_db[i] != START_END)  // Check if it's not the start/end signal
							$write("\033[32m%s\033[0m", decode_output(aligned_db[i]));
					end
					
					$display("");
					
				end
				
				sw_qry_out.out_letters = aligned_qry;
				sw_db_out.out_letters = aligned_db;
				
				sw_qry_out_analysis_port.write(sw_qry_out);
				sw_db_out_analysis_port.write(sw_db_out);
				sw_score_analysis_port.write(max_score);
				
			end
		end
		join_none
		
	endtask
	

	// Task to compute the Smith-Waterman score and aligned sequences
	task compute_alignment(seq_t qry, seq_t db, output int unsigned max_score, output bit [2:0] aligned_qry[$], output bit [2:0] aligned_db[$]);
		int unsigned score_matrix[][]; // Declare as a dynamic array
		int unsigned len_qry = SEQ_LENGTH;  // Use $size to get the size of qry
		int unsigned len_db = SEQ_LENGTH;  // Use $size to get the size of db
		int unsigned i, j;
		int unsigned sum;
		int unsigned max_row, max_col;
		int unsigned score_diagonal, score_up, score_left;
		int unsigned qry_letter, db_letter;
		
		if (debug_level >= 2) begin
			$display("Length of query (len_qry): %0d", len_qry);
			$display("Length of database (len_db): %0d", len_db);
		end

		// Initialize score matrix
		score_matrix = new[len_qry + 1]; // Allocate rows
		foreach (score_matrix[i]) begin
			score_matrix[i] = new[len_db + 1]; // Allocate columns for each row
		end
		initialize_matrix(score_matrix, len_qry, len_db);
		
		
		if (debug_level >= 2) begin
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
		for (sum = 2; sum <= len_db + len_qry; sum++) begin
			// Iterate over diagonals, bottom to top
			for (i = len_db; i >= 1; i--) begin
				int j = sum - i; // Calculate column index
				if (j < 1 || j > len_qry) continue; // Skip out-of-bound indices

				qry_letter = qry.data[(i-1)/4][((i-1)%4)*2 +: 2];
				db_letter = db.data[(j-1)/4][((j-1)%4)*2 +: 2];

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

				if (debug_level >= 3) begin
					$display("Filling score_matrix[%0d][%0d]: diag=%0d, up=%0d, left=%0d -> max=%0d",
							 i, j, score_diagonal, score_up, score_left, score_matrix[i][j]);
				end
			end
		end
		
		if (debug_level >= 2) begin
			$display("Score matrix after filling:");
			for (i = 0; i <= len_qry; i++) begin
				for (j = 0; j <= len_db; j++) begin
					$write("%0d ", score_matrix[i][j]);
				end
				$display("");
			end
		end
		
		// Print max_row and max_col after filling the score matrix
		if (debug_level >= 2) begin
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
	function void traceback(ref int unsigned matrix[][], seq_t qry, seq_t db, 	
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
			if (debug_level >= 2) begin
				$display("At i = %0d, j = %0d", i, j);
			end
			
			if (matrix[i][j] == 0) break;
			
			// Decode 2-bit letters
			qry_letter = qry.data[(i-1)/4][((i-1)%4)*2 +: 2];
			db_letter = db.data[(j-1)/4][((j-1)%4)*2 +: 2];

			// Match/mismatch
			if (matrix[i][j] == matrix[i-1][j-1] + ((qry_letter == db_letter) ? MATCH_SCORE : -MISMATCH_SCORE)) begin
				aligned_qry[idx] = encode_output(qry_letter);
				aligned_db[idx] = encode_output(db_letter);
				i--;
				j--;
			end
			// Gap in qry
			else if (matrix[i][j] == matrix[i-1][j] - GAP_PENALTY) begin
				aligned_qry[idx] = encode_output(qry_letter);
				aligned_db[idx] = GAP;
				i--;
			end
			// Gap in db
			else if (matrix[i][j] == matrix[i][j-1] - GAP_PENALTY) begin
				aligned_qry[idx] = GAP;
				aligned_db[idx] = encode_output(db_letter);
				j--;
			end
			idx++;
		end
		
		if (debug_level >= 2) begin
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
	
	// Function to convert the encoded values to nucleotides or gap
	function [8*1:0] decode_output(bit [2:0] output_letter);
		case (output_letter)
			OUT_A: decode_output = "A";
			OUT_G: decode_output = "G";
			OUT_T: decode_output = "T";
			OUT_C: decode_output = "C";
			START_END: decode_output = "^";
			GAP: decode_output = "-";
			default: decode_output = "?"; // Undefined input
		endcase
	endfunction

endclass
