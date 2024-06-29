class clk_rst_cvg_collector extends uvm_component;

    clk_cvg clk_cvg_h;
    rst_cvg rst_cvg_h;

    function new(string name, uvm_compnent parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        clk_cvg_h = new();
        rst_cvg_h = new();

    endfunction 
    
endclass : clk_rst_cvg_collector