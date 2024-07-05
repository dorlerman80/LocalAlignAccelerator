class virtual_seq extends uvm_component;

    `uvm_component_utils(virtual_seq)
    rst_seq rst_seq_h;
    clk_seq clk_seq_h;
    
    function new(string name, uvm_component parent);
        super.new(name , parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rst_seq_h = rst_seq::type_id::create("rst_seq_h");
        clk_seq_h = clk_seq::type_id::create("clk_seq_h");
    endfunction


	virtual task start_and_trigger_seq(input clk_sqr clk_sqr_inst, input rst_sqr rst_sqr_inst);
		fork
			begin
				clk_seq_h.start(clk_sqr_inst);
			end

			begin
				rst_seq_h.start(rst_sqr_inst);
			end
		join_none // Use join_none for non-blocking fork-join
	endtask

endclass : virtual_seq
    

