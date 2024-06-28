class clk_seq extends uvm_sequence #(clk_pkt);
    `uvm_object_utils(clk_seq)

    function new(string name = "clk_sequence");
        super.new(name); 
        uvm_config_int::get(null, "*", "clk_pkt_num", clk_pkt_num);
        uvm_config_int::get(null, "*", "is_default_clk_seq", is_default_seq);
    endfunction


    virtual task body();

        send_pkt(clk_cfg_val);
        else
            // test implementation


    endtask

    virtual task send_pkt(input clk_cfg_val)
        clk_pkt = clk_pkt::type_id::create("clk_pkt")
        start_item(clk_pkt);
        set_pkt_vals(clk_pkt, clk_cfg_val);
        finish_item(clk_pkt);
    endtask

    virtual task set_pkt_vals(input clk_pkt, input clk_cfg_val)
        if(clk_cfg_val = DEFAULT) begin // TODO: define default value as enum
            clk_pkt.clk_period_ns = 10; // TODO: configured value
            clk_pkt.duty_cycle_percent = 50; // TODO: configured value
            clk_pkt.clk_on = 1; // TODO: configured value
        end

        else if(clk_cfg_val = CFG_1) begin
            // TODO: define what to do in this configuration
        end

    endtask
    
endclass