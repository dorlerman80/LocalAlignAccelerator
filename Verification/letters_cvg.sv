class letters_cvg #(int SEQ_LENGTH = 32) extends uvm_component;

	`uvm_component_param_utils(letters_cvg)

	// Declare the covergroup outside the class body
	covergroup letters_cg with function sample (int num_similar_letters);
	   coverpoint num_similar_letters {
		  bins num_similar_letters_bins[] = {[0:SEQ_LENGTH]}; 
	   }
	endgroup

	int similar_count;
	uvm_analysis_imp#(seq_t, letters_cvg) qry_analysis_export;
	uvm_analysis_imp#(seq_t, letters_cvg) db_analysis_export;

	logic [design_variables::NUM_INSERT_CYCLES-1:0][design_variables::INPUT_WIDTH-1:0] qry_t;
	logic [design_variables::NUM_INSERT_CYCLES-1:0][design_variables::INPUT_WIDTH-1:0] db_t;

	bit qry_valid = 0;
	bit db_valid = 0;

	// Constructor
	function new(string name = "letters_cvg", uvm_component parent = null);
	   super.new(name, parent);

	   qry_analysis_export = new("qry_analysis_export", this);
	   db_analysis_export = new("db_analysis_export", this);

	   letters_cg = new();
	   `uvm_info("letters_cvg", "letters_cvg constructor called", UVM_HIGH)
	endfunction

	// Write function
	virtual function void write(seq_t t);
	   // Temporary variables for the sequence items
	   seq_t qry_data;
	   seq_t db_data;

	   // Check the type by comparing fields or using a custom field
	   if (is_query_type(t)) begin
		  qry_t = t.data;  // Assign data from seq_t
		  qry_valid = 1;
		  `uvm_info("letters_cvg", $sformatf("Query type detected. Data: %b", qry_t), UVM_HIGH)
	   end
	   else if (is_database_type(t)) begin
		  db_t = t.data;  // Assign data from seq_t
		  db_valid = 1;
		  `uvm_info("letters_cvg", $sformatf("Database type detected. Data: %b", db_t), UVM_HIGH)
	   end

	   // If both qry_valid and db_valid are set, count similar pairs
	   if (qry_valid && db_valid) begin
		  `uvm_info("letters_cvg", "Both query and database data are valid. Counting similar pairs...", UVM_HIGH)
		  count_similar_pairs(qry_t, db_t);
		  qry_valid = 0;
		  db_valid = 0;
	   end
	endfunction

	// Function to check if 't' is of type seq_t
	function bit is_query_type(seq_t t);
	   `uvm_info("letters_cvg", $sformatf("Checking if seq_t is query type (t.typ == 0): %0d", t.typ), UVM_HIGH)
	   if (t.typ == 0) begin  // Assuming `type == 0` for query
		  return 1;
	   end
	   return 0;
	endfunction

	// Function to check if 't' is of type seq_t
	function bit is_database_type(seq_t t);
	   `uvm_info("letters_cvg", $sformatf("Checking if seq_t is database type (t.typ == 1): %0d", t.typ), UVM_HIGH)
	   if (t.typ == 1) begin  // Assuming `type == 1` for database
		  return 1;
	   end
	   return 0;
	endfunction
	
	
	typedef enum bit [1:0] {A = 2'b00, G = 2'b01, T = 2'b10, C = 2'b11} input_encoding_t;
	// Function to convert the encoded values to nucleotides
	function [8*1:0] decode_input(bit [1:0] input_letter);
		case (input_letter)
			A: decode_input = "A";  // Corresponds to 2'b00
			G: decode_input = "G";  // Corresponds to 2'b01
			T: decode_input = "T";  // Corresponds to 2'b10
			C: decode_input = "C";  // Corresponds to 2'b11
			default: decode_input = "?";  // Undefined input
		endcase
	endfunction
	

	// Count similar pairs function
	virtual function void count_similar_pairs(
	   logic [design_variables::SEQ_LENGTH*2-1:0] qry_t, 
	   logic [design_variables::SEQ_LENGTH*2-1:0] db_t);
	   
		string qry_decoded = "";
		string db_decoded = "";

		// Decode the sequences
		`uvm_info("INPUT_DB", $sformatf("Input DB Seq Data: %b", db_t), UVM_HIGH);
		`uvm_info("INPUT_QRY", $sformatf("Input QRY Seq Data: %b", qry_t), UVM_HIGH);

		for (int i = 0; i < SEQ_LENGTH; i++) begin
			qry_decoded = {qry_decoded, string'(decode_input(qry_t[i*2 +: 2]))};
			db_decoded = {db_decoded, string'(decode_input(db_t[i*2 +: 2]))};
		end

		`uvm_info("INPUT_QRY", $sformatf("\033[1;34mDecoded QRY Seq: %s\033[0m", qry_decoded), UVM_MEDIUM);
		`uvm_info("INPUT_DB", $sformatf("\033[1;34mDecoded DB Seq: %s\033[0m", db_decoded), UVM_MEDIUM);

	   
	   similar_count = 0;

	   // Print the results of the comparison after looping
	   `uvm_info("letters_cvg", "Counting similar pairs...", UVM_HIGH)
	   for (int i = 0; i < SEQ_LENGTH; i++) begin
		  if ((qry_t[i] == db_t[i]) && (qry_t[i+1] == db_t[i+1])) begin
			 similar_count++;
		  end
	   end

	   `uvm_info("letters_cvg", $sformatf("Total similar pairs found: %0d", similar_count), UVM_MEDIUM)
	   letters_cg.sample(similar_count);
	endfunction
 endclass
