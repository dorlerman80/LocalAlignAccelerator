module tb_top;

    import sw_pkg::*;

    sw_if sw_if(); 

    SW_DUT sw_i (
                .clk(sw_if.clk),
                .rst_n(sw_if.rst_n)
            );

    initial begin 

        sw_if.rst_n = 1;
        uvm_config_db#(virtual sw_if)::set(null,"*","sw_if",sw_if);

        run_test("base_test");
    end


endmodule : tb_top

