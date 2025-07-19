class start_cvg #(int LOW_START_DURATION_TIME = 10, int HIGH_START_DURATION_TIME = 100);

	covergroup start_cg with function sample (int start_duration_ns);
		
		start_duration_time_cp : coverpoint (start_duration_ns)
		{
			bins duration_time_ns_bins [] = {[LOW_START_DURATION_TIME:HIGH_START_DURATION_TIME]};
		}

	endgroup

	function new();
		start_cg = new();
		start_cg.option.name = $sformatf("start_coverage");
	endfunction

endclass