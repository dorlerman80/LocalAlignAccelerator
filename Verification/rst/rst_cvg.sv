class rst_cvg #(int LOW_RST_DURATION_TIME = 10, int HIGH_RST_DURATION_TIME = 100);

    covergroup rst_cg with function sample (int rst_duration_ns);
        
        rst_duration_time_cp : coverpoint (rst_duration_ns)
        {
            bins duration_time_ns_bins [] = {[LOW_RST_DURATION_TIME:HIGH_RST_DURATION_TIME]};
        }

    endgroup

    function new();
        rst_cg = new();
        rst_cg.option.name = $sformatf("reset_coverage");
    endfunction

endclass