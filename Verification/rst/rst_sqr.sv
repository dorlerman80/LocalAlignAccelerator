class rst_sqr extends uvm_sequencer #(rst_pkt);

	`uvm_component_param_utils(rst_sqr)

	function new(string name = "rst_sqr", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Created instance of ", get_full_name()}, UVM_HIGH)
	endfunction

endclass : rst_sqr
