class clk_rst_test extends base_test;

	`uvm_component_utils(clk_rst_test)

	// Clock and Reset configuration objects
	clk_test_cfg clk_cfg;
	rst_test_cfg rst_cfg;

	// Constructor
	function new(string name = "clk_rst_test", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("CLK_RST_BASE_TEST_NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM);
	endfunction : new

	// Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("CLK_RST_BASE_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Create and configure reset configuration object
		rst_cfg = rst_test_cfg::new("rst_cfg");
		rst_cfg.set_random_values();  // Set random values for reset configuration
		rst_cfg.apply_to_config_db(); // Apply the configuration to uvm_config_db

		`uvm_info("CLK_RST_BASE_TEST_BUILD", {"Configured reset settings using rst_test_cfg"}, UVM_MEDIUM);

		// Create and configure clock configuration object
		clk_cfg = clk_test_cfg::new("clk_cfg");
		clk_cfg.set_random_values();  // Set random values for clock configuration
		clk_cfg.apply_to_config_db(); // Apply the configuration to uvm_config_db

		`uvm_info("CLK_RST_BASE_TEST_BUILD", {"Configured clock settings using clk_test_cfg"}, UVM_MEDIUM);

		`uvm_info("CLK_RST_BASE_TEST_BUILD", {"clk_rst_test build phase complete"}, UVM_MEDIUM);
	endfunction : build_phase

	// Connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("CLK_RST_BASE_TEST_CONNECT", {"Connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction : connect_phase 

	// Run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("RUN_CLK_RST_BASE_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		// Additional run phase behavior can be added here
	endtask : run_phase

endclass : clk_rst_test
