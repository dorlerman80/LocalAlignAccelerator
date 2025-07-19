class qry_seq_in_sqr extends uvm_sequencer #(qry_seq_in_pkt);

	`uvm_component_param_utils(qry_seq_in_sqr)

	function new(string name, uvm_component parent);
	  super.new(name, parent);
	  `uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction

  endclass : qry_seq_in_sqr