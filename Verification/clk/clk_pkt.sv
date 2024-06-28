class clk_pkt extends uvm_seqeunce_item;
    `uvm_object_utils(clk_pkt)

    int clk_period_ns = 10;
    int duty_cycle_percent = 50; 
    bit clk_on;

    function new(string name = "clk_pkt");
        super.new(name);
    endfunction
endclass




    

