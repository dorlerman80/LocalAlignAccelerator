class letters_test extends base_test;

	`uvm_component_utils(letters_test)

	// Letters configuration object
	letters_test_cfg letters_cfg;

	// Constructor
	function new(string name = "letters_test", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("LETTERS_TEST_NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM);
	endfunction : new

	// Build phase
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("LETTERS_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Create and configure letters_test_cfg object
		letters_cfg = letters_test_cfg::new("letters_cfg");
		
		// Set default values for required fields
		letters_cfg.set_defaults();

		// Set random values for letters configuration
		letters_cfg.set_random_values();

		// Apply the configuration to the uvm_config_db
		letters_cfg.apply_to_config_db();

		`uvm_info("LETTERS_TEST_BUILD", {"Configured letters test settings using letters_test_cfg"}, UVM_MEDIUM);

		`uvm_info("LETTERS_TEST_BUILD", {"letters_test build phase complete"}, UVM_MEDIUM);
	endfunction : build_phase

	// Connect phase
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("LETTERS_TEST_CONNECT", {"Connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction : connect_phase 

	// Run phase
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("RUN_LETTERS_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		// Additional run phase behavior can be added here
	endtask : run_phase

endclass : letters_test
