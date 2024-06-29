class clk_seq extends uvm_sequence #(clk_pkt);
    `uvm_object_utils(clk_seq)

    // Parameters for the sequence
    int unsigned clk_pkt_num;

    // Enum for configuration values
    clk_cfg_enum clk_cfg_val;


    function new(string name = "clk_sequence");

        super.new(name); 
        
        // Retrieve clk_pkt_num from the config_db
        if (!uvm_config_int::get(null, "*", "clk_pkt_num", clk_pkt_num)) begin
            `uvm_error("CFG_ERR", "Failed to get clk_pkt_num from config_db")
        end

        // Retrieve the configuration from the config_db
        if (!uvm_config_db#(clk_cfg_enum)::get(this, "", "clk_cfg_val", clk_cfg_val)) begin
            `uvm_error("CFG_ERR", "Failed to get clk_cfg_val from config_db")
        end

    endfunction

    virtual task body();

        send_clk_pkts(clk_pkt_num, clk_cfg_val);

    endtask


    virtual task send_clk_pkts(input clk_pkt_num,input clk_cfg_val);
        clk_pkt pkt;

        for (int i = 0; i < clk_pkt_num; i++) begin

            pkt = clk_pkt::type_id::create($sformatf("clk_pkt_%0d", i));

            start_item(pkt);
            set_clk_pkt(pkt);
            finish_item(pkt);

            if(clk_cfg_val != DEFAULT) begin
                delay = $urandom_range(300, 4000);
                #delay;
            end
        end
    endtask

    virtual task set_clk_pkt(clk_pkt pkt);

        case (clk_cfg_val)
            DEFAULT: begin
                pkt.clock_period_ns = 10;
                pkt.duty_cycle_percent = 50;
                pkt.clk_on = 1;
            end
            
            DIFF_PERIOD: begin
                int min_period, max_period;

                if (!uvm_config_int::get(this, "*", "min_period", min_period)) min_period = 2;
                if (!uvm_config_int::get(this, "*", "max_period", max_period)) max_period = 10;

                pkt.clock_period_ns = $urandom_range(min_period, max_period);
                pkt.duty_cycle_percent = 50;
                pkt.clk_on = 1;
            end

            DIFF_DUTY_CYCLE: begin
                int min_duty_cycle, max_duty_cycle;

                if (!uvm_config_int::get(this, "*", "min_duty_cycle", min_duty_cycle)) min_duty_cycle = 30;
                if (!uvm_config_int::get(this, "*", "max_duty_cycle", max_duty_cycle)) max_duty_cycle = 70;

                pkt.clock_period_ns = 10;
                pkt.duty_cycle_percent = $urandom_range(min_duty_cycle, max_duty_cycle);
                pkt.clk_on = 1;

            DIFF_BOTH: 
                int min_period, max_period;
                int min_duty_cycle, max_duty_cycle;


                if (!uvm_config_int::get(this, "*", "min_period", min_period)) min_period = 2;
                if (!uvm_config_int::get(this, "*", "max_period", max_period)) max_period = 10;
                if (!uvm_config_int::get(this, "*", "min_duty_cycle", min_duty_cycle)) min_duty_cycle = 30;
                if (!uvm_config_int::get(this, "*", "max_duty_cycle", max_duty_cycle)) max_duty_cycle = 70;

                pkt.clock_period_ns = $urandom_range(min_period, max_period);
                pkt.duty_cycle_percent = $urandom_range(min_duty_cycle, max_duty_cycle);
                pkt.clk_on = 1;
            end

            DIFF_BOTH_CLK_RND:
                int min_period, max_period;
                int min_duty_cycle, max_duty_cycle;


                if (!uvm_config_int::get(this, "*", "min_period", min_period)) min_period = 2;
                if (!uvm_config_int::get(this, "*", "max_period", max_period)) max_period = 10;
                if (!uvm_config_int::get(this, "*", "min_duty_cycle", min_duty_cycle)) min_duty_cycle = 30;
                if (!uvm_config_int::get(this, "*", "max_duty_cycle", max_duty_cycle)) max_duty_cycle = 70;

                pkt.clock_period_ns = $urandom_range(min_period, max_period);
                pkt.duty_cycle_percent = $urandom_range(min_duty_cycle, max_duty_cycle);
                pkt.clk_on = $urandom_range(0,1);

            default: begin
                `uvm_error("CFG_ERR", "Must set one of the configuration values")
            end
        endcase
    endtask
    
endclass : clk_seq


