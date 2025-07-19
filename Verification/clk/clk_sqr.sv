class clk_sqr extends uvm_sequencer #(clk_pkt);
	`uvm_component_param_utils(clk_sqr)

	// Constructor for the clk_sqr class
	function new(string name = "clk_sqr", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", $sformatf("Created instance of %s", get_full_name()), UVM_HIGH)
	endfunction

endclass : clk_sqr
