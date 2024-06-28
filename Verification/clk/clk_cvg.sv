class clk_cvg;
    //implement clk_cg with function sample
    

    
    function new();
        clk_cg = new();
        clk_cg.option.name = $sformatf("clock_coverage");
    endfunction

endclass