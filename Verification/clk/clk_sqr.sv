class clk_sqr extends uvm_sequencer #(clk_pkt);

    `uvm_component_utils(clk_sqr)

    function new(string name, uvm_component parent);
        super.new(name); 
    endfunction

endclass : clk_sqr
