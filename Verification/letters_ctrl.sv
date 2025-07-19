class letters_ctrl extends uvm_component;
	`uvm_component_utils(letters_ctrl)

	// Parameters
	int unsigned seq_in_pkt_num;
	int seq_num_letters;
	int unsigned mask_probability;

	// FIFO declarations for qry and db sequence packets
	uvm_tlm_fifo #(qry_seq_in_pkt) qry_fifo;
	uvm_tlm_fifo #(db_seq_in_pkt) db_fifo;

	// Randomized variable for letter mask
	bit [design_variables::INPUT_WIDTH/2-1:0] letter_mask;

	// Constructor to initialize the component
	function new(string name = "letters_ctrl", uvm_component parent = null);
		super.new(name, parent);
		qry_fifo = new("qry_fifo", this);
		db_fifo = new("db_fifo", this);
	endfunction

	// Build phase to initialize configuration
	virtual function void build_phase(uvm_phase phase);
		if (!uvm_config_db#(int unsigned)::get(null, "*", "seq_in_pkt_num", seq_in_pkt_num)) begin
			`uvm_error("CFG_ERR", "Failed to get seq_in_pkt_num from config_db");
		end else begin
			`uvm_info("BUILD", $sformatf("Retrieved seq_in_pkt_num=%0d", seq_in_pkt_num), UVM_HIGH);
		end

		if (!uvm_config_db#(int)::get(null, "*", "seq_num_letters", seq_num_letters)) begin
			`uvm_error("CFG_ERR", "Failed to get seq_num_letters from config_db");
		end else begin
			`uvm_info("BUILD", $sformatf("Retrieved seq_num_letters=%0d", seq_num_letters), UVM_HIGH);
		end

		if (!uvm_config_db#(int unsigned)::get(null, "*", "mask_probability", mask_probability)) begin
			`uvm_error("CFG_ERR", "Failed to get mask_probability from config_db");
		end else begin
			`uvm_info("BUILD", $sformatf("Retrieved mask_probability=%0d", mask_probability), UVM_HIGH);
		end
	endfunction

	// Randomize the letter mask based on mask_probability
	virtual function bit [design_variables::INPUT_WIDTH/2-1:0] randomize_letter_mask();
		bit [design_variables::INPUT_WIDTH/2-1:0] mask;

		foreach (mask[i]) begin
			// Generates a random number between 0 and 99
			if ($urandom % 100 < mask_probability) begin
				mask[i] = 1; // Set the bit to 1 with the specified probability
			end else begin
				mask[i] = 0; // Otherwise set it to 0
			end
		end

		return mask;
	endfunction

	// Generate and randomize qry_pkt without applying the mask initially
	virtual function qry_seq_in_pkt randomize_qry_pkt(int pkt_idx, int trans_idx);
		qry_seq_in_pkt qry_pkt = qry_seq_in_pkt::type_id::create($sformatf("qry_pkt_%0d_%0d", pkt_idx, trans_idx));

		if (!qry_pkt.randomize()) begin
			`uvm_error("CTRL_RAND_ERR", "Failed to fully randomize qry_pkt");
		end
		return qry_pkt;
	endfunction

	// Apply the mask on qry_pkt and use it to randomize db_pkt with constraints
	virtual function db_seq_in_pkt randomize_db_pkt(qry_seq_in_pkt qry_pkt, bit [3:0] letter_mask, int pkt_idx, int trans_idx);
		// Create the db_pkt object
		db_seq_in_pkt db_pkt = db_seq_in_pkt::type_id::create($sformatf("db_pkt_%0d_%0d", pkt_idx, trans_idx));

		// Iterate with step of 2 to access pairs of bits in seq_in_letters
		for (int i = 0; i < design_variables::INPUT_WIDTH; i = i + 2) begin
			// Check the corresponding bit in the mask (either bit i or i+1 of the mask)
			if (letter_mask[i/2] == 1) begin
				// If mask bit is 1, copy the corresponding bits from qry_pkt
				db_pkt.seq_in_letters[i +: 2] = qry_pkt.seq_in_letters[i +: 2];
			end else begin
				// Otherwise, randomize the corresponding bits in db_pkt
				db_pkt.seq_in_letters[i +: 2] = $urandom;
			end
		end

		// Return the populated db_pkt
		return db_pkt;
	endfunction

	// Generate qry and db packets, using a mask for db_pkt based on the randomized qry_pkt
	virtual task generate_packets(int pkt_idx, int num_transactions);
		for (int trans_idx = 0; trans_idx < num_transactions; trans_idx++) begin
			// Step 1: Randomize qry_pkt without mask
			qry_seq_in_pkt qry_pkt = randomize_qry_pkt(pkt_idx, trans_idx);

			// Step 2: Generate a random mask
			bit [design_variables::INPUT_WIDTH/2-1:0] letter_mask = randomize_letter_mask();

			// Step 3: Randomize db_pkt with the mask applied on qry_pkt
			db_seq_in_pkt db_pkt = randomize_db_pkt(qry_pkt, letter_mask, pkt_idx, trans_idx);
			
			// Put the generated packets into the FIFO queues
			qry_fifo.put(qry_pkt);
			db_fifo.put(db_pkt);
			
			// Print db_pkt.data in binary format
			`uvm_info("CTRL_PKT", $sformatf("Generated qry_pkt %0d:%0d - data (binary): %b", pkt_idx, trans_idx, qry_pkt.seq_in_letters), UVM_HIGH);
			`uvm_info("CTRL_PKT", $sformatf("Generated db_pkt %0d:%0d - data (binary): %b", pkt_idx, trans_idx, db_pkt.seq_in_letters), UVM_HIGH);
			`uvm_info("CTRL_PKT", $sformatf("Generated packets %0d:%0d with mask %b", pkt_idx, trans_idx, letter_mask), UVM_HIGH);

		end
	endtask

	// Main run phase
	virtual task run_phase(uvm_phase phase);
		int pkt_num_letters = design_variables::INPUT_WIDTH / design_variables::LETTER_WIDTH;
		int num_transactions = seq_num_letters / pkt_num_letters;

		for (int pkt_idx = 0; pkt_idx < seq_in_pkt_num; pkt_idx++) begin
			generate_packets(pkt_idx, num_transactions);
		end
	endtask

endclass
