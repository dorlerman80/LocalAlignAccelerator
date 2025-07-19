class simple_test extends base_test;

	`uvm_component_utils(simple_test)

	function new(string name = "simple_test", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("SIMPLE_TEST_NEW", {"Creating instance of ", get_full_name()}, UVM_MEDIUM);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("SIMPLE_TEST_BUILD", {"Starting build phase for ", get_full_name()}, UVM_MEDIUM);

		// Reset configuration
		uvm_config_db#(int)::set(null, "*", "rst_pkt_num", 1);
		uvm_config_db#(rst_cfg_enum)::set(null, "*", "rst_cfg_val", RST_CFG_DEFAULT);

		// Clock configuration
		uvm_config_db#(int)::set(null, "*", "clk_pkt_num", 1000);
		uvm_config_db#(clk_cfg_enum)::set(null, "*", "clk_cfg_val", CLK_CFG_DEFAULT);

		// Sequence input configuration
		uvm_config_db#(int unsigned)::set(null, "*", "seq_in_pkt_num", 1);
		uvm_config_db#(int)::set(null, "*", "seq_num_letters", design_variables::SEQ_LENGTH);
		uvm_config_db#(int unsigned)::set(null, "*", "mask_probability", 0);
		
		// Start configuration
		uvm_config_db#(int)::set(null, "*", "start_pkt_num", 1); 
		uvm_config_db#(start_cfg_enum)::set(null, "*", "start_cfg_val", START_CFG_DEFAULT); 

		`uvm_info("SIMPLE_TEST_BUILD", {"Configured simple test settings"}, UVM_MEDIUM);
		`uvm_info("SIMPLE_TEST_BUILD", {"simple_test build phase complete"}, UVM_MEDIUM);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("SIMPLE_TEST_CONNECT", {"Connect phase for ", get_full_name()}, UVM_MEDIUM);
	endfunction : connect_phase 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("RUN_SIMPLE_TEST", {"Run phase started for ", get_full_name()}, UVM_MEDIUM);
		// Additional run phase behavior can be added here
	endtask : run_phase

endclass : simple_test
