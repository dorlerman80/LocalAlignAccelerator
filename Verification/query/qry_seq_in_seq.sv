class qry_seq_in_seq extends uvm_sequence #(qry_seq_in_pkt);
	`uvm_object_param_utils(qry_seq_in_seq)

	// Parameters for the sequence
	int unsigned seq_in_pkt_num;
	int seq_num_letters;
	
	uvm_tlm_fifo #(qry_seq_in_pkt) qry_fifo;

	function new(string name = "qry_seq_in_seq");
		super.new(name); 
		
		qry_fifo = new("qry_fifo", null);
		
		// Retrieve seq_in_pkt_num from the config_db
		if (!uvm_config_db#(int unsigned)::get(null, "*", "seq_in_pkt_num", seq_in_pkt_num)) begin
			`uvm_error("CFG_ERR", "Failed to get seq_in_pkt_num from config_db")
		end else begin
			`uvm_info("SEQ_NUM", $sformatf("seq_in_pkt_num retrieved: %0d", seq_in_pkt_num), UVM_HIGH);
		end
		
		// Retrieve full_seq_length from the config_db
		if (!uvm_config_db#(int)::get(null, "*", "seq_num_letters", seq_num_letters)) begin
			`uvm_error("CFG_ERR", "Failed to get seq_num_letters from config_db")
		end else begin
			`uvm_info("SEQ_LEN", $sformatf("seq_num_letters retrieved: %0d", seq_num_letters), UVM_HIGH);
		end
	endfunction

	virtual task body();
		`uvm_info("BODY", "Starting to generate letter packets", UVM_MEDIUM);
		gen_letter_pkts(seq_num_letters, seq_in_pkt_num);
	endtask
	
	virtual task gen_letter_pkts(input int full_seq_len, input int seq_in_pkt_num);
		qry_seq_in_pkt letters_pkt;
		int pkt_num_letters;
		int num_transactions;

		pkt_num_letters = design_variables::INPUT_WIDTH / design_variables::LETTER_WIDTH;
		num_transactions = seq_num_letters / pkt_num_letters;

		for (int pkt_idx = 0; pkt_idx < seq_in_pkt_num; pkt_idx++) begin
			`uvm_info("PKT_GEN", $sformatf("Generating packet %0d", pkt_idx), UVM_HIGH);
			for (int i = 0; i < num_transactions; i++) begin
				
				qry_seq_in_pkt letters_pkt;
				
				qry_fifo.get(letters_pkt);
				if (!letters_pkt) begin
				  `uvm_error("FIFO_ERROR", "Failed to get from db_fifo");
				end
				
				start_item(letters_pkt);
				
				finish_item(letters_pkt);
			end
		end
	endtask
	
endclass : qry_seq_in_seq

//class qry_seq_in_seq extends uvm_sequence #(qry_seq_in_pkt);
//	`uvm_object_param_utils(qry_seq_in_seq)
//
//	// Parameters for the sequence
//	int unsigned seq_in_pkt_num;
//	int seq_num_letters;
//
//	function new(string name = "qry_seq_in_seq");
//		super.new(name); 
//		
//		// Retrieve seq_in_pkt_num from the config_db
//		if (!uvm_config_db#(int unsigned)::get(null, "*", "seq_in_pkt_num", seq_in_pkt_num)) begin
//			`uvm_error("CFG_ERR", "Failed to get seq_in_pkt_num from config_db")
//		end else begin
//			`uvm_info("SEQ_NUM", $sformatf("seq_in_pkt_num retrieved: %0d", seq_in_pkt_num), UVM_HIGH);
//		end
//		
//		// Retrieve full_seq_length from the config_db
//		if (!uvm_config_db#(int)::get(null, "*", "seq_num_letters", seq_num_letters)) begin
//			`uvm_error("CFG_ERR", "Failed to get seq_num_letters from config_db")
//		end else begin
//			`uvm_info("SEQ_LEN", $sformatf("seq_num_letters retrieved: %0d", seq_num_letters), UVM_HIGH);
//		end
//	endfunction
//
//	virtual task body();
//		`uvm_info("BODY", "Starting to generate letter packets", UVM_MEDIUM);
//		gen_letter_pkts(seq_num_letters, seq_in_pkt_num);
//	endtask
//	
//	virtual task gen_letter_pkts(input int full_seq_len, input int seq_in_pkt_num);
//		qry_seq_in_pkt letters_pkt;
//		int pkt_num_letters;
//		int num_transactions;
//
//		pkt_num_letters = design_variables::INPUT_WIDTH / design_variables::LETTER_WIDTH;
//		num_transactions = seq_num_letters / pkt_num_letters;
//
//		for (int pkt_idx = 0; pkt_idx < seq_in_pkt_num; pkt_idx++) begin
//			`uvm_info("PKT_GEN", $sformatf("Generating packet %0d", pkt_idx), UVM_HIGH);
//			for (int i = 0; i < num_transactions; i++) begin
//				letters_pkt = qry_seq_in_pkt::type_id::create($sformatf("qry_seq_in_pkt_%0d_%0d", pkt_idx, i));
//				
//				start_item(letters_pkt);
//				// TODO: Add constraints for letters_pkt if needed
//				if (!letters_pkt.randomize()) begin
//					`uvm_error("RAND_ERR", "Failed to randomize letters_pkt");
//				end else begin
//					`uvm_info("RAND_PKT", $sformatf("Randomized qry_seq_in_letters in packet %0d: %0h", pkt_idx, letters_pkt.seq_in_letters), UVM_HIGH);
//				end
//				
//				finish_item(letters_pkt);
//			end
//		end
//	endtask
//	
//endclass : qry_seq_in_seq
