class db_seq_in_sqr extends uvm_sequencer #(db_seq_in_pkt);

	`uvm_component_param_utils(db_seq_in_sqr)

	function new(string name, uvm_component parent);
		super.new(name, parent);
		
		// Log the creation of the sequencer instance
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction

endclass : db_seq_in_sqr
