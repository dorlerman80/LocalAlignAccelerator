class clk_test_cfg extends uvm_object;

	`uvm_object_param_utils(clk_test_cfg)

	// Configuration parameters specific to clk_test
	int clk_pkt_num;
	clk_cfg_enum clk_cfg_val;
	int min_period;
	int max_period;
	int min_duty_cycle;
	int max_duty_cycle;

	// Constructor
	function new(string name = "clk_test_cfg");
	  super.new(name);
	endfunction

	// Method to set random values for the configuration parameters
	function void set_random_values();
	  // Randomize clk_pkt_num between 500 and 1500
	  clk_pkt_num = $urandom_range(500, 1500);

	  // Randomly select clk_cfg_val from the enum values
	  clk_cfg_val = clk_cfg_enum'($urandom_range(0, 5));

	  // Randomize min_period and max_period between 2 and 10, with max > min
	  min_period = $urandom_range(2, 9);
	  max_period = $urandom_range(min_period + 1, 10);

	  // Randomize min_duty_cycle and max_duty_cycle between 30 and 70, with max > min
	  min_duty_cycle = $urandom_range(30, 69);
	  max_duty_cycle = $urandom_range(min_duty_cycle + 1, 70);
	endfunction

	// Method to apply the configuration parameters to the config_db
	function void apply_to_config_db();
	  uvm_config_db#(int)::set(null, "*", "clk_pkt_num", clk_pkt_num);
	  uvm_config_db#(clk_cfg_enum)::set(null, "*", "clk_cfg_val", clk_cfg_val);
	  uvm_config_db#(int)::set(null, "*", "min_period", min_period);
	  uvm_config_db#(int)::set(null, "*", "max_period", max_period);
	  uvm_config_db#(int)::set(null, "*", "min_duty_cycle", min_duty_cycle);
	  uvm_config_db#(int)::set(null, "*", "max_duty_cycle", max_duty_cycle);
	endfunction

endclass : clk_test_cfg
