class clk_cvg #(int CLK_PERIOD_LOW_NS = 2,int CLK_PERIOD_HIGH_NS = 10,int DUTY_CYCLE_HIGH = 70,int DUTY_CYCLE_LOW = 30);

    covergroup clk_cg with function sample (int clk_period_ns, int duty_cycle_percent , bit clk_on);
        
        duty_cycle_cp : coverpoint (duty_cycle_percent)
        {
            bins duty_cycle_bins [] = {[DUTY_CYCLE_LOW:DUTY_CYCLE_HIGH]};
        }

        clk_period_cp : coverpoint(clk_period_ns)
        {
            bins clk_period_bins [] = {[CLK_PERIOD_LOW_NS:CLK_PERIOD_HIGH_NS]};
        }

        clk_on_cp : coverpoint(clk_on)
        {
            bins clk_on_bins [] = {[0:1]};
        }

    endgroup

    
    function new();
        clk_cg = new();
        clk_cg.option.name = $sformatf("clock_coverage");
    endfunction

endclass