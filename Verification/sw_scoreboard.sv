class sw_scoreboard extends uvm_scoreboard;

	`uvm_component_param_utils(sw_scoreboard)

	// Declare Analysis Imps and FIFOs
	`uvm_analysis_imp_decl(_sw_qry)
	`uvm_analysis_imp_decl(_sw_db)
	`uvm_analysis_imp_decl(_sw_score)
	
	
	`uvm_analysis_imp_decl(_ref_qry)
	`uvm_analysis_imp_decl(_ref_db)
	`uvm_analysis_imp_decl(_ref_score)
	

	// Analysis exports
	uvm_analysis_imp_sw_qry #(out_seq_t, sw_scoreboard) sw_qry_analysis_export;
	uvm_analysis_imp_sw_db #(out_seq_t, sw_scoreboard) sw_db_analysis_export;
	uvm_analysis_imp_sw_score #(int unsigned, sw_scoreboard) sw_score_analysis_export;
	
	uvm_analysis_imp_ref_qry #(out_seq_t, sw_scoreboard) ref_qry_analysis_export;
	uvm_analysis_imp_ref_db #(out_seq_t, sw_scoreboard) ref_db_analysis_export;
	uvm_analysis_imp_ref_score #(int unsigned, sw_scoreboard) ref_score_analysis_export;

	// FIFOs to store sequences
	uvm_tlm_analysis_fifo #(out_seq_t) sw_qry_fifo;  // FIFO for switch query data
	uvm_tlm_analysis_fifo #(out_seq_t) sw_db_fifo;   // FIFO for switch database data
	uvm_tlm_analysis_fifo #(int unsigned) sw_score_fifo; 
	
	uvm_tlm_analysis_fifo #(out_seq_t) ref_qry_fifo;  // FIFO for switch query data
	uvm_tlm_analysis_fifo #(out_seq_t) ref_db_fifo;   // FIFO for switch database data
	uvm_tlm_analysis_fifo #(int unsigned) ref_score_fifo; 

	out_seq_t ref_qry;
	out_seq_t ref_db;
	out_seq_t sw_qry;
	out_seq_t sw_db;
	
	int unsigned sw_score;
	int unsigned ref_score;
	
	bit qry_match;
	bit db_match;
	bit score_match;

	function new(string name = "sw_scoreboard", uvm_component parent);
	  super.new(name, parent);

	  // Initialize analysis exports
	  sw_qry_analysis_export = new("sw_qry_analysis_export", this);
	  sw_db_analysis_export = new("sw_db_analysis_export", this);
	  sw_score_analysis_export = new("sw_score_analysis_export", this);
	  
	  ref_qry_analysis_export = new("ref_qry_analysis_export", this);
	  ref_db_analysis_export = new("ref_db_analysis_export", this);
	  ref_score_analysis_export = new("ref_score_analysis_export", this);
	  
	  // Initialize FIFOs
	  sw_qry_fifo = new("sw_qry_fifo", this);
	  sw_db_fifo = new("sw_db_fifo", this);
	  sw_score_fifo = new("sw_score_fifo", this);
	  
	  ref_qry_fifo = new("ref_qry_fifo", this);
	  ref_db_fifo = new("ref_db_fifo", this);
	  ref_score_fifo = new("ref_score_fifo", this);
	  
	endfunction

	// Write methods for SW analysis exports
	virtual function void write_sw_qry(out_seq_t qry_out);
	  sw_qry_fifo.write(qry_out); // Write to FIFO
	  `uvm_info("WRITE_SW_QRY", $sformatf("Packet written to sw_qry_fifo: %p", qry_out), UVM_MEDIUM);
	endfunction

	virtual function void write_sw_db(out_seq_t db_out);
	  sw_db_fifo.write(db_out); // Write to FIFO
	  `uvm_info("WRITE_SW_DB", $sformatf("Packet written to sw_db_fifo: %p", db_out), UVM_MEDIUM);
	endfunction
	
	virtual function void write_sw_score(int unsigned sw_score);
		sw_score_fifo.write(sw_score); // Write to FIFO
		`uvm_info("WRITE_SW_SCORE", $sformatf("Score written to sw_score_fifo: %d", sw_score), UVM_MEDIUM);
	  endfunction
	
	
	// Write methods for REF analysis exports
	virtual function void write_ref_qry(out_seq_t ref_qry_out);
	  ref_qry_fifo.write(ref_qry_out); // Write to FIFO
	  `uvm_info("WRITE_REF_QRY", $sformatf("Packet written to ref_qry_fifo: %p", ref_qry_out), UVM_MEDIUM);
	endfunction

	virtual function void write_ref_db(out_seq_t ref_db_out);
	  ref_db_fifo.write(ref_db_out); // Write to FIFO
	  `uvm_info("WRITE_REF_DB", $sformatf("Packet written to ref_db_fifo: %p", ref_db_out), UVM_MEDIUM);
	endfunction
	
	virtual function void write_ref_score(int unsigned ref_score);
		ref_score_fifo.write(ref_score); // Write to FIFO
		`uvm_info("WRITE_REF_SCORE", $sformatf("Score written to ref_score_fifo: %d", ref_score), UVM_MEDIUM);
	  endfunction
	
	

	// Compare function
	virtual task compare(output bit result);
		fork begin
		  forever begin
			// Wait for data in both FIFOs
			sw_qry_fifo.get(sw_qry);
			sw_db_fifo.get(sw_db);
			sw_score_fifo.get(sw_score);
			
			ref_qry_fifo.get(ref_qry);
			ref_db_fifo.get(ref_db);
			ref_score_fifo.get(ref_score);
	
			// Perform qry and db comparisons
			qry_match = qry_compare(sw_qry, ref_qry);
			db_match = db_compare(sw_db, ref_db);
			score_match = score_compare(sw_score, ref_score);
	
			// Log results
			if (qry_match && db_match) begin
				`uvm_info("COMPARE", "\033[1;32mCurrent sequences matched!\033[0m", UVM_MEDIUM);
                                 result=1;
				if(score_match) begin
					`uvm_info("COMPARE", "\033[1;32mOutput scores matched!\033[0m", UVM_MEDIUM);
				end
			end 
			else begin
			  if (!qry_match) begin
				  `uvm_info("UVM_ERROR", "\033[1;31mQuery sequences do not match.\033[0m", UVM_MEDIUM);
                                  result=0;
			  end
			  if (!db_match) begin
				  `uvm_info("UVM_ERROR", "\033[1;31mDatabase sequences do not match.\033[0m", UVM_MEDIUM);
                                  result=0;
			  end
			  if(!score_match) begin
				  `uvm_info("UVM_ERROR", "\033[1;31mOutput scores do not match.\033[0m", UVM_MEDIUM);
				  result=0;
			  end
			  
			  
			end
		  end
		end
		join_none
	
	endtask
	
	typedef enum bit [2:0] {OUT_A = 3'b000, OUT_G = 3'b001, OUT_T = 3'b010, OUT_C = 3'b011, GAP = 3'b100, START_END = 3'b111} output_encoding_t;
	// Function to convert the encoded values to nucleotides or gap
	function [8*1:0] decode_output(bit [2:0] output_letter);
		case (output_letter)
			OUT_A: decode_output = "A";
			OUT_G: decode_output = "G";
			OUT_T: decode_output = "T";
			OUT_C: decode_output = "C";
			START_END: decode_output = "";
			GAP: decode_output = "-";
			default: decode_output = "?"; // Undefined input
		endcase
	endfunction
	
	
	// Query Comparison
	virtual function bit qry_compare(out_seq_t sw_qry, out_seq_t ref_qry);
	  // Compare bit by bit
	  
		string ref_decoded = "";
		string sw_decoded = "";

		// Decode each letter in ref_qry
		foreach (ref_qry.out_letters[i]) begin
		  ref_decoded = {ref_decoded, string'(decode_output(ref_qry.out_letters[i]))};
		end

		// Decode each letter in sw_qry
		foreach (sw_qry.out_letters[i]) begin
		  sw_decoded = {sw_decoded, string'(decode_output(sw_qry.out_letters[i]))};
		end
	  
	  if (ref_qry.out_letters == sw_qry.out_letters) begin
		  
		  `uvm_info("QRY_COMPARE", 
				  $sformatf("\033[1;32mMatch: ref_qry = %s, sw_qry = %s\033[0m", ref_decoded, sw_decoded), 
				  UVM_MEDIUM);
		  
		return 1; // Match
	  end 
	  
	  else begin

		// Log the mismatch with decoded sequences
		`uvm_info("QRY_COMPARE", 
		  $sformatf("\033[1;31mMismatch: ref_qry = %s, sw_qry = %s\033[0m", ref_decoded, sw_decoded), 
		  UVM_MEDIUM);
		return 0; // Mismatch
	  end
	endfunction

	// Database Comparison
	virtual function bit db_compare(out_seq_t sw_db, out_seq_t ref_db);
		
		
		string ref_decoded = "";
		string sw_decoded = "";

		// Decode each letter in ref_db
		foreach (ref_db.out_letters[i]) begin
		  ref_decoded = {ref_decoded, string'(decode_output(ref_db.out_letters[i]))};
		end

		// Decode each letter in sw_db
		foreach (sw_db.out_letters[i]) begin
		  sw_decoded = {sw_decoded, string'(decode_output(sw_db.out_letters[i]))};
		end
	  // Compare bit by bit
	  if (ref_db.out_letters == sw_db.out_letters) begin
		  `uvm_info("DB_COMPARE", 
				  $sformatf("\033[1;32mMatch: ref_db = %s, sw_db = %s\033[0m", ref_decoded, sw_decoded), 
				  UVM_MEDIUM);
		return 1; // Match
	  end else begin


		// Log the mismatch with decoded sequences
		`uvm_info("DB_COMPARE", 
		  $sformatf("\033[1;31mMismatch: ref_db = %s, sw_db = %s\033[0m", ref_decoded, sw_decoded), 
		  UVM_MEDIUM);
		return 0; // Mismatch
	  end
	endfunction


	// Database Comparison
	virtual function bit score_compare(int unsigned sw_score, int unsigned ref_score);

		if (sw_score == ref_score) begin
			`uvm_info("SCORE_COMPARE", 
					  $sformatf("\033[1;32mMatch: ref_score = %0d, sw_score = %0d\033[0m", ref_score, sw_score), 
					  UVM_MEDIUM);
			return 1; 
		end

		`uvm_info("SCORE_COMPARE", 
				  $sformatf("\033[1;31mMismatch: ref_score = %0d, sw_score = %0d\033[0m", ref_score, sw_score), 
				  UVM_MEDIUM);
		return 0; // Mismatch

	endfunction
	

  endclass
