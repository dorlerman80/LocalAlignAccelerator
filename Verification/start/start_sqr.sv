class start_sqr extends uvm_sequencer #(start_pkt);

	`uvm_component_param_utils(start_sqr)

	function new(string name, uvm_component parent);
	  super.new(name, parent);
	  `uvm_info("NEW", {"Created instance of ", get_full_name()}, UVM_HIGH)
	endfunction

endclass : start_sqr
