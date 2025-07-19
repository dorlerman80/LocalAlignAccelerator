class rst_test_cfg extends uvm_object;

	`uvm_object_param_utils(rst_test_cfg)

	// Configuration parameters specific to rst_test
	int rst_pkt_num;
	rst_cfg_enum rst_cfg_val;
	int min_rst_duration_ns;
	int max_rst_duration_ns;

	// Constructor
	function new(string name = "rst_test_cfg");
		super.new(name);
	endfunction

	// Method to set default values for the configuration parameters
	function void set_defaults();
		rst_pkt_num = 10;
		rst_cfg_val = DIFF_DURATION;
		min_rst_duration_ns = 10;
		max_rst_duration_ns = 100;
	endfunction

	// Method to apply the configuration parameters to the config_db
	function void apply_to_config_db();
		uvm_config_db#(int)::set(null, "*", "rst_pkt_num", rst_pkt_num);
		uvm_config_db#(rst_cfg_enum)::set(null, "*", "rst_cfg_val", rst_cfg_val);
		uvm_config_db#(int)::set(null, "*", "min_rst_duration_ns", min_rst_duration_ns);
		uvm_config_db#(int)::set(null, "*", "max_rst_duration_ns", max_rst_duration_ns);
	endfunction

	// Method to randomize the configuration parameters
	function void set_random_values();
		rst_pkt_num = $urandom_range(5, 20);  // Random value between 5 and 20
		rst_cfg_val = rst_cfg_enum'( $urandom_range(0, 1) ); // Random enum value
		min_rst_duration_ns = $urandom_range(10, 99); // Random min value between 5 and 20
		max_rst_duration_ns = $urandom_range(min_rst_duration_ns + 1, 100); // max > min
	endfunction

endclass : rst_test_cfg
