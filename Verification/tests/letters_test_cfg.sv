class letters_test_cfg extends uvm_object;

	`uvm_object_param_utils(letters_test_cfg)

	// Configuration parameters specific to letters_test
	int unsigned seq_in_pkt_num;
	int seq_num_letters;
	int unsigned mask_probability;

	// Constructor
	function new(string name = "letters_test_cfg");
		super.new(name);
	endfunction

	// Method to set default values for the configuration parameters
	function void set_defaults();
		seq_in_pkt_num = 20;
		seq_num_letters = design_variables::SEQ_LENGTH;
		mask_probability = 20;
	endfunction

	// Method to apply the configuration parameters to the config_db
	function void apply_to_config_db();
		uvm_config_db#(int unsigned)::set(null, "*", "seq_in_pkt_num", seq_in_pkt_num);
		uvm_config_db#(int)::set(null, "*", "seq_num_letters", seq_num_letters);
		uvm_config_db#(int unsigned)::set(null, "*", "mask_probability", mask_probability);
	endfunction

	// Method to randomize the configuration parameters
	function void set_random_values();
		seq_in_pkt_num = $urandom_range(10, 50); // Random value between 10 and 50
		mask_probability = $urandom_range(0, 100); // Random value between 0 and 100
	endfunction

endclass : letters_test_cfg
