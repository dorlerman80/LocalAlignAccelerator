class control_cvg_collector extends uvm_component;
	
	`uvm_component_param_utils(control_cvg_collector)
	
	start_cvg start_cvg_h;
	score_cvg score_cvg_h;

	function new(string name, uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		start_cvg_h = new();
		score_cvg_h = new();

	endfunction 
	
endclass : control_cvg_collector