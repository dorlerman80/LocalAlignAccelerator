class score_cvg #(int MAXIMUM_SCORE=32);

	covergroup score_cg with function sample (int score_value);
		
		score_cp : coverpoint (score_value)
		{
			bins score_bins [] = {[0:MAXIMUM_SCORE]};
		}

	endgroup

	function new();
		score_cg = new();
		score_cg.option.name = $sformatf("start_coverage");
	endfunction

endclass