class qry_seq_in_pkt extends base_seq_in_pkt;

	`uvm_object_param_utils(qry_seq_in_pkt)

	function new(string name = "qry_seq_in_pkt");
	  super.new(name);
	  `uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction
	
 endclass : qry_seq_in_pkt