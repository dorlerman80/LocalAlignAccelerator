class start_test extends base_test;

	`uvm_component_utils(start_test)
	
	// Start configuration object
	start_test_cfg start_cfg;

	// Constructor
	function new(string name = "start_test", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("START_TEST_NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM);
	endfunction : new

	// Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("START_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Create and configure start_test_cfg object
		start_cfg = start_test_cfg::new("start_cfg");
		
		// Set default values
		start_cfg.set_defaults();

		// Set random values for start configuration
		start_cfg.set_random_values();

		// Apply the configuration to the uvm_config_db
		start_cfg.apply_to_config_db();

		`uvm_info("START_TEST_BUILD", {"Configured start settings using start_test_cfg"}, UVM_MEDIUM);

		`uvm_info("START_TEST_BUILD", {"start_test build phase complete"}, UVM_MEDIUM);
	endfunction : build_phase

	// Connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("START_TEST_CONNECT", {"Connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction : connect_phase 

	// Run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("RUN_START_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		// Additional run phase behavior can be added here
	endtask : run_phase

endclass : start_test
