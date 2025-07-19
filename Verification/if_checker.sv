module if_checker (sw_if sw_if);

	// properties
	property score_unchanged_when_consecutive_output_valid;
		@(posedge sw_if.clk) disable iff(!sw_if.rst_n) (sw_if.output_valid & $past(sw_if.output_valid)) |-> (sw_if.score == $past(sw_if.score));
	endproperty
	
	property check_unknown_letters;
		@(posedge sw_if.clk) disable iff(!sw_if.rst_n) (sw_if.output_valid) |-> (~$isunknown(sw_if.query_seq_out) & ~$isunknown(sw_if.database_seq_out));
	endproperty
	
	property check_ready_deassertion;
		@(posedge sw_if.clk) disable iff(!sw_if.rst_n) (sw_if.start & sw_if.ready |=> (~sw_if.ready));
	endproperty
	
	property check_zero_score_begin_of_comp;
		@(posedge sw_if.clk) disable iff(!sw_if.rst_n) (sw_if.start & sw_if.ready |=> ##1 (sw_if.score==0));
	endproperty
	
	property letters_inserted_max_one_cycle_after_handshake;
		@(posedge sw_if.clk) disable iff (!sw_if.rst_n)
		(sw_if.ready && sw_if.start) |-> 
		##[0:1] ((!$isunknown($past(sw_if.query_seq_in)) && !$isunknown($past(sw_if.database_seq_in))) &&
				 (sw_if.query_seq_in != $past(sw_if.query_seq_in)) &&
				 (sw_if.database_seq_in != $past(sw_if.database_seq_in)));
	endproperty

	property start_is_single_cycle_pulse;
		@(posedge sw_if.clk) disable iff(!sw_if.rst_n) ($rose(sw_if.start) |=> $fell(sw_if.start));
	endproperty


	// assertions
	assert property (score_unchanged_when_consecutive_output_valid)
		else `uvm_error("ASSERTION_ERROR", "Error: Score changed while output_valid was asserted for consecutive cycles.");

  	assert property (check_unknown_letters)
		else `uvm_error("ASSERTION_ERROR", "Error: Letters are unknown while output_valid is asserted.");

  	assert property (check_ready_deassertion)
		else `uvm_error("ASSERTION_ERROR", "Error: ready signal did not deassert after start and ready were asserted.");
  
	assert property (check_zero_score_begin_of_comp)
		else `uvm_error("ASSERTION_ERROR", "Error: Score is not zero in the beginning of computation");

  	assert property (letters_inserted_max_one_cycle_after_handshake)
	  else `uvm_error("ASSERTION_ERROR", "Error: Insertion did not occur within 1 cycle after the handshake (ready & start).");

  	assert property (start_is_single_cycle_pulse)
	  else `uvm_error("ASSERTION_ERROR", "Error: start signal is not a single cycle pulse.");


endmodule