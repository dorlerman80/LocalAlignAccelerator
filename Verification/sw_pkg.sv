
package sw_pkg;

    // UVM
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // variables definitions
    `include "../Design/RTL/design_variables.vh"

    // interface
    `include "sw_if.sv"

    // clk
    `include "clk_agent.sv"
    `include "clk_driver.sv"
    `include "clk_monitor.sv"
    `include "clk_sqr.sv"
    `include "clk_seq.sv"
    `include "clk_pkt.sv"
endpackage
