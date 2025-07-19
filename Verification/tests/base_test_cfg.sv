class base_test_cfg extends uvm_object;

	`uvm_object_param_utils(base_test_cfg)

	// Configuration parameters
	int rst_pkt_num;
	rst_cfg_enum rst_cfg_val;

	int clk_pkt_num;
	clk_cfg_enum clk_cfg_val;
	int min_period;
	int max_period;
	int min_duty_cycle;
	int max_duty_cycle;

	int start_pkt_num;
	start_cfg_enum start_cfg_val;

	int unsigned seq_in_pkt_num;
	int seq_num_letters;
	int unsigned mask_probability;

	function new(string name = "base_test_cfg");
	  super.new(name);
	endfunction

	// Method to set default values
	function void set_defaults();
	  rst_pkt_num = 1;
	  rst_cfg_val = RST_CFG_DEFAULT;

	  clk_pkt_num = 2000;
	  clk_cfg_val = CLK_CFG_DEFAULT;
	  min_period = 2;
	  max_period = 300;
	  min_duty_cycle = 30;
	  max_duty_cycle = 70;

	  start_pkt_num = 20;
	  start_cfg_val = START_CFG_DEFAULT;

	  seq_in_pkt_num = 15;
	  seq_num_letters = design_variables::SEQ_LENGTH;
	  mask_probability = 0;
	endfunction

	// Method to set values in the config_db
	function void apply_to_config_db();
	  uvm_config_db#(int)::set(null, "*", "rst_pkt_num", rst_pkt_num);
	  uvm_config_db#(rst_cfg_enum)::set(null, "*", "rst_cfg_val", rst_cfg_val);

	  uvm_config_db#(int)::set(null, "*", "clk_pkt_num", clk_pkt_num);
	  uvm_config_db#(clk_cfg_enum)::set(null, "*", "clk_cfg_val", clk_cfg_val);
	  uvm_config_db#(int)::set(null, "*", "min_period", min_period);
	  uvm_config_db#(int)::set(null, "*", "max_period", max_period);
	  uvm_config_db#(int)::set(null, "*", "min_duty_cycle", min_duty_cycle);
	  uvm_config_db#(int)::set(null, "*", "max_duty_cycle", max_duty_cycle);

	  uvm_config_db#(int)::set(null, "*", "start_pkt_num", start_pkt_num);
	  uvm_config_db#(start_cfg_enum)::set(null, "*", "start_cfg_val", start_cfg_val);

	  uvm_config_db#(int unsigned)::set(null, "*", "seq_in_pkt_num", seq_in_pkt_num);
	  uvm_config_db#(int)::set(null, "*", "seq_num_letters", seq_num_letters);
	  uvm_config_db#(int unsigned)::set(null, "*", "mask_probability", mask_probability);
	endfunction

  endclass : base_test_cfg
