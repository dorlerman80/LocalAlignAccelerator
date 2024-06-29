
package sw_pkg;

    // UVM
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // variables definitions
    // `include "../Design/RTL/design_variables.vh"
    `include "verif_utils.sv"
    import verif_utils::*;

    // env
    `include "sw_env.sv"

    // virtual sequence
    `include "virtual_seq.sv"

    // interface
    `include "sw_if.sv"

    // clk
    `include "./clk/clk_agent.sv"
    `include "./clk/clk_driver.sv"
    `include "./clk/clk_monitor.sv"
    `include "./clk/clk_sqr.sv"
    `include "./clk/clk_seq.sv"
    `include "./clk/clk_pkt.sv"
    `include "./clk/clk_cvg.sv"

    // rst
    `include "./rst/rst_agent.sv"
    `include "./rst/rst_driver.sv"
    `include "./rst/rst_monitor.sv"
    `include "./rst/rst_sqr.sv"
    `include "./rst/rst_seq.sv"
    `include "./rst/rst_pkt.sv"
    `include "./rst/rst_cvg.sv"

endpackage
