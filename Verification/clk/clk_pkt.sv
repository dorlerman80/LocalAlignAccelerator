class clk_pkt extends uvm_sequence_item;

    `uvm_object_utils(clk_pkt)

    int clk_period_ns;
    int duty_cycle_percent;
    bit clk_on;

    function new(string name = "clk_pkt");
        super.new(name);
    endfunction
endclass : clk_pkt




    

