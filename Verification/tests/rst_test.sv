class rst_test extends base_test;

	`uvm_component_utils(rst_test)
	
	// Reset configuration object
	rst_test_cfg rst_cfg;

	// Constructor
	function new(string name = "rst_test", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("RST_TEST_NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM);
	endfunction : new

	// Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("RST_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Create and configure rst_test_cfg object
		rst_cfg = rst_test_cfg::new("rst_cfg");
		
		// Set default values
		rst_cfg.set_defaults();

		// Set random values for reset configuration
		rst_cfg.set_random_values();

		// Apply the configuration to the uvm_config_db
		rst_cfg.apply_to_config_db();

		`uvm_info("RST_TEST_BUILD", {"Configured reset settings using rst_test_cfg"}, UVM_MEDIUM);

		`uvm_info("RST_TEST_BUILD", {"rst_test build phase complete"}, UVM_MEDIUM);
	endfunction : build_phase

	// Connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("RST_TEST_CONNECT", {"Connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction : connect_phase 

	// Run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("RUN_RST_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		// Additional run phase behavior can be added here
	endtask : run_phase

endclass : rst_test
