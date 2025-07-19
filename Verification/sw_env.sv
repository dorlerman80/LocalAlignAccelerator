class sw_env extends uvm_env;

	`uvm_component_param_utils(sw_env)
	
	// Agents
	clk_agent clk_agent_h;
	rst_agent rst_agent_h;
	
	db_seq_in_agent db_agent_h;
	db_seq_out_agent db_out_agent_h;
	qry_seq_in_agent qry_agent_h;
	qry_seq_out_agent qry_out_agent_h;
	
	start_agent start_agent_h;
	score_agent score_agent_h;
	
	// Coverages
	clk_rst_cvg_collector clk_rst_cov_h;
	control_cvg_collector control_cov_h;
	letters_cvg#(design_variables::SEQ_LENGTH) letters_cov_h;

	// virtual sequence
	virtual_seq v_seq;
	

	function new(string name = "sw_env", uvm_component parent = null);
		super.new(name, parent);
		`uvm_info("NEW", {"Creating instance of ", get_full_name()}, UVM_HIGH);
	endfunction : new

	function void build_phase(uvm_phase phase);
		`uvm_info("BUILD", {"Build phase of env", get_full_name()}, UVM_HIGH);
		super.build_phase(phase);
		
		// Create agents
		clk_agent_h = clk_agent::type_id::create("clk_agent_h", this);
		rst_agent_h = rst_agent::type_id::create("rst_agent_h", this);
		db_agent_h = db_seq_in_agent::type_id::create("db_agent_h", this);
		db_out_agent_h = db_seq_out_agent::type_id::create("db_out_agent_h", this);
		qry_agent_h = qry_seq_in_agent::type_id::create("qry_agent_h", this);
		qry_out_agent_h = qry_seq_out_agent::type_id::create("qry_out_agent_h", this);
		start_agent_h = start_agent::type_id::create("start_agent_h", this);
		score_agent_h = score_agent::type_id::create("score_agent_h", this);
		
		// Create coverages
		clk_rst_cov_h = clk_rst_cvg_collector::type_id::create("clk_rst_cov_h", this);
		control_cov_h = control_cvg_collector::type_id::create("control_cov_h", this);
		letters_cov_h = letters_cvg#()::type_id::create("letters_cov_h", this);

		// Create virtual sequence
		v_seq = virtual_seq::type_id::create("v_seq", this);
		
		`uvm_info("BUILD", {"Environment build phase complete"}, UVM_HIGH);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		
		// Connect rst and clk
		rst_agent_h.rst_monitor_h.rst_cvg_h = clk_rst_cov_h.rst_cvg_h;
		clk_agent_h.clk_monitor_h.clk_cvg_h = clk_rst_cov_h.clk_cvg_h;

		`uvm_info("CONNECT", $sformatf("Coverage groups connected: rst_cvg_h = %p, clk_cvg_h = %p", 
				rst_agent_h.rst_monitor_h.rst_cvg_h, 
				clk_agent_h.clk_monitor_h.clk_cvg_h), UVM_HIGH);
		
		// Connect start and score
		start_agent_h.start_monitor_h.start_cvg_h = control_cov_h.start_cvg_h;
		score_agent_h.score_monitor_h.score_cvg_h = control_cov_h.score_cvg_h;
		
		`uvm_info("CONNECT", $sformatf("Coverage groups connected: start_cvg_h = %p, score_cvg_h = %p", 
				start_agent_h.start_monitor_h.start_cvg_h, 
				score_agent_h.score_monitor_h.score_cvg_h), UVM_HIGH);

		// Connect database and query
		 db_agent_h.db_analysis_port_h.connect(letters_cov_h.db_analysis_export);
		 qry_agent_h.qry_analysis_port_h.connect(letters_cov_h.qry_analysis_export);

		 `uvm_info("CONNECT", $sformatf("Analysis ports connected: db_agent_h = %p, qry_agent_h = %p", 
		         db_agent_h.db_analysis_port_h, 
		         qry_agent_h.qry_analysis_port_h), UVM_HIGH);
		 
	endfunction : connect_phase

	function void start_of_simulation_phase(uvm_phase phase);
		`uvm_info("SIMULATION_START", {"Start of simulation for ", get_full_name()}, UVM_HIGH);
	endfunction : start_of_simulation_phase

endclass : sw_env
