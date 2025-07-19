class start_test_cfg extends uvm_object;

	`uvm_object_param_utils(start_test_cfg)

	// Configuration parameters specific to start_test
	int start_pkt_num;
	start_cfg_enum start_cfg_val;
	int min_start_duration_ns;
    int max_start_duration_ns;

	// Constructor
	function new(string name = "start_test_cfg");
		super.new(name);
	endfunction

	// Method to set default values for the configuration parameters
	function void set_defaults();
		start_pkt_num = 20;
		start_cfg_val = DIFF_DURATION_START;
		min_start_duration_ns = 10;
		max_start_duration_ns = 100;
	endfunction

	// Method to apply the configuration parameters to the config_db
	function void apply_to_config_db();
		uvm_config_db#(int)::set(null, "*", "start_pkt_num", start_pkt_num);
		uvm_config_db#(start_cfg_enum)::set(null, "*", "start_cfg_val", start_cfg_val);
		uvm_config_db#(int)::set(null, "*", "min_start_duration_ns", min_start_duration_ns);
		uvm_config_db#(int)::set(null, "*", "max_start_duration_ns", max_start_duration_ns);
	endfunction

	// Method to randomize the configuration parameters
	function void set_random_values();
		start_pkt_num = $urandom_range(10, 50); // Random value between 10 and 50
		start_cfg_val = start_cfg_enum'( $urandom_range(0, 1) ); // Random enum value
		min_start_duration_ns = $urandom_range(10, 99); // Random value between 10 and 99
		max_start_duration_ns = $urandom_range(min_start_duration_ns, 100); // Random value between min and 100
	endfunction

endclass : start_test_cfg
