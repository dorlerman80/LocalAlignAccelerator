`timescale 1ns / 1ps

module tb_top;
    import sw_pkg::*;

    sw_if sw_if(); 
	if_checker if_checker_i (.sw_if(sw_if));

	top sw_i (
		// Clock & reset
		.clk(sw_if.clk),
		.rst_n(sw_if.rst_n),
		
		// Inputs
		.start(sw_if.start),
		.query_seq_in(sw_if.query_seq_in),
		.database_seq_in(sw_if.database_seq_in),
		.inverter_in(sw_if.inverter_in),     
		.flipflop_in(sw_if.flipflop_in),     
		
		// Outputs
		.ready(sw_if.ready),
		.query_seq_out(sw_if.query_seq_out),  
		.database_seq_out(sw_if.database_seq_out), 
		.score(sw_if.score),                  
		.output_valid(sw_if.output_valid),   
		.inverter_out(sw_if.inverter_out),   
		.flipflop_out(sw_if.flipflop_out)   
	);

    initial begin 

//      sw_if.rst_n = 1;
//		sw_if.ready = 0; // TODO: change this
		sw_if.start = 0; // TODO: change this
		sw_if.inverter_in = 0;
		sw_if.flipflop_in = 0;
        uvm_config_db#(virtual sw_if)::set(null,"*","sw_if",sw_if);
         
        run_test("base_test");
	end
	
	initial begin
		$fsdbDumpfile("logs/simulation.fsdb");
		$fsdbDumpvars(0, tb_top);
	end


endmodule : tb_top

