class clk_test extends base_test;

	`uvm_component_utils(clk_test)
	
	// Clock configuration object
	clk_test_cfg clk_cfg;

	// Constructor
	function new(string name = "clk_test", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("CLK_TEST_NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM);
	endfunction : new

	// Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("CLK_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Create and configure clk_test_cfg object
		clk_cfg = clk_test_cfg::new("clk_cfg");

		// Set random values for clock configuration
		clk_cfg.set_random_values();

		// Apply the configuration to the uvm_config_db
		clk_cfg.apply_to_config_db();

		`uvm_info("CLK_TEST_BUILD", {"Configured clock settings using clk_test_cfg"}, UVM_MEDIUM);

		`uvm_info("CLK_TEST_BUILD", {"clk_test build phase complete"}, UVM_MEDIUM);
	endfunction : build_phase

	// Connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("CLK_TEST_CONNECT", {"Connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction : connect_phase 

	// Run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("RUN_CLK_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		// Additional run phase behavior can be added here
	endtask : run_phase

endclass : clk_test
