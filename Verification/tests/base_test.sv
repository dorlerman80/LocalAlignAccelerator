class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	sw_env sw_env_h;
	sw_scoreboard sw_scoreboard_h;
	sw_ref_model ref_model;
	base_test_cfg test_cfg; // Declare an instance of base_test_cfg

	bit pass_condition = 0;

	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BASE_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Create configuration object
		test_cfg = base_test_cfg::type_id::create("test_cfg", this);
		test_cfg.set_defaults();  // Set default values

		// Apply config values to the config_db
		test_cfg.apply_to_config_db();
		`uvm_info("BASE_TEST_BUILD", {"Applied configuration from base_test_cfg object"}, UVM_MEDIUM);

		// Create other components
		sw_env_h = sw_env::type_id::create("sw_env_h", this);
		`uvm_info("BASE_TEST_BUILD", {"Created sw_env_h instance: ", sw_env_h.get_full_name()}, UVM_MEDIUM);
		
		sw_scoreboard_h = sw_scoreboard::type_id::create("sw_scoreboard_h", this);
		`uvm_info("BASE_TEST_BUILD", {"Created sw_scoreboard_h instance: ", sw_scoreboard_h.get_full_name()}, UVM_MEDIUM);
		
		// Create ref model
		ref_model = sw_ref_model::type_id::create("ref_model", this);
		`uvm_info("BASE_TEST_BUILD", {"Created ref_model instance: ", ref_model.get_full_name()}, UVM_MEDIUM);

		// Configuration is now handled by base_test_cfg and applied via apply_to_config_db
		// No need to manually set values via uvm_config_db here
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		
		sw_env_h.qry_out_agent_h.qry_seq_out_monitor_h.qry_analysis_port.connect(sw_scoreboard_h.sw_qry_analysis_export);
		sw_env_h.db_out_agent_h.db_seq_out_monitor_h.db_analysis_port.connect(sw_scoreboard_h.sw_db_analysis_export);
		sw_env_h.score_agent_h.score_monitor_h.score_analysis_port.connect(sw_scoreboard_h.sw_score_analysis_export);
		
		// connect ref model to scoreboard to send the output letters 
		ref_model.sw_qry_out_analysis_port.connect(sw_scoreboard_h.ref_qry_analysis_export);
		ref_model.sw_db_out_analysis_port.connect(sw_scoreboard_h.ref_db_analysis_export);
		ref_model.sw_score_analysis_port.connect(sw_scoreboard_h.ref_score_analysis_export);
		
		// connect seq_in agents to ref model to send input letters
		sw_env_h.qry_agent_h.qry_analysis_port_h.connect(ref_model.sw_qry_in_analysis_export);
		sw_env_h.db_agent_h.db_seq_in_monitor_h.db_analysis_port.connect(ref_model.sw_db_in_analysis_export);
		
		`uvm_info("BASE_TEST_CONNECT", {"End of connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		`uvm_info("BASE_TEST_ELABORATION", {"End of elaboration phase for ", get_full_name()}, UVM_MEDIUM);
		
		// Print the UVM topology
		uvm_top.print_topology();

		// Print the contents of the config_db
		uvm_config_db #(int)::dump();
	endfunction : end_of_elaboration_phase

	task run_phase(uvm_phase phase);
		`uvm_info("RUN_BASE_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		
		phase.raise_objection(.obj(this));
		`uvm_info("RUN_BASE_TEST", {"Objection raised for run phase"}, UVM_MEDIUM);

		// Start and trigger sequences
		sw_env_h.v_seq.start_and_trigger_seq(
			sw_env_h.clk_agent_h.clk_sequencer_h, 
			sw_env_h.rst_agent_h.rst_sequencer_h, 
			sw_env_h.db_agent_h.db_seq_in_sqr_h,
			sw_env_h.qry_agent_h.qry_seq_in_sqr_h,
			sw_env_h.start_agent_h.start_sequencer_h
		);
		
		// run the algorithm of the ref model
		ref_model.perform_sw_algorithm();
		
		// Run the compare task concurrently
		sw_scoreboard_h.compare(pass_condition);
 
		`uvm_info("RUN_BASE_TEST", {"Sequences started, waiting for 40000 time units"}, UVM_MEDIUM);
		
		#40000;
		
		`uvm_info("RUN_BASE_TEST", {"Dropping objection for run phase"}, UVM_MEDIUM);
		phase.drop_objection(.obj(this));
		`uvm_info("RUN_BASE_TEST", {"Run phase completed for ", get_full_name()}, UVM_MEDIUM);
		
		pass_condition = 1;
	endtask
	
	function void report_phase(uvm_phase phase);
		if (pass_condition)
		  `uvm_info("TEST_PASS", "TEST PASSED", UVM_LOW)
		else
		  `uvm_error("TEST_FAIL", "TEST FAILED")
	endfunction

endclass : base_test
