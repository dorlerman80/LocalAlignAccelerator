/*------------------------------------------------------------------------------
 * File          : max_registers_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 27, 2023
 * Description   :
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module max_registers_tb;
import design_variables::*;

// Inputs
logic clk;
logic rst_n;
logic wr_en_max;
logic [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][SCORE_WIDTH-1:0] score_in;
logic [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][ROW_BITS_WIDTH-1:0] row_in;
logic [COMPARE_UNITS_LVL_1-1:0][NUM_VALS_LVL_1-1:0][COL_BITS_WIDTH-1:0] col_in;

// Output
logic [SCORE_WIDTH-1:0] max_score;
logic [ROW_BITS_WIDTH-1:0] max_row;
logic [COL_BITS_WIDTH-1:0] max_col;

// Instantiate the DUT
max_registers dut (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en_max(wr_en_max),
    .score_in(score_in),
    .row_in(row_in),
    .col_in(col_in),
    .max_score(max_score),
    .max_row(max_row),
    .max_col(max_col)
);

// Clock generator
always begin
    #5 clk = ~clk;
end

// Test stimulus
initial begin
    // Initialize inputs with random values
    rst_n = 0;
    clk = 0;
    wr_en_max = 0;
    score_in = '0;
    row_in = '0;
    col_in = '0;

    // Wait for a few cycles
    #10

    // Release reset and enable write
    rst_n = 1;
    wr_en_max = 1;

    // Generate random test case
    for (int i = 0; i < COMPARE_UNITS_LVL_1; i++) begin
        for (int j = 0; j < NUM_VALS_LVL_1; j++) begin
            score_in[i][j] = $urandom_range(0, 255);
            row_in[i][j] = i*j;
            col_in[i][j] = i*j;
        end
    end

    #20

    for (int i = 0; i < COMPARE_UNITS_LVL_1; i++) begin
        for (int j = 0; j < NUM_VALS_LVL_1; j++) begin
            score_in[i][j] = $urandom_range(0, 255);
            row_in[i][j] = i*j;
            col_in[i][j] = i*j;
        end
    end

    #20

    for (int i = 0; i < COMPARE_UNITS_LVL_1; i++) begin
        for (int j = 0; j < NUM_VALS_LVL_1; j++) begin
            score_in[i][j] = $urandom_range(0, 255);
            row_in[i][j] = i*j;
            col_in[i][j] = i*j;
        end
    end

    // End simulation
    $finish;
end

endmodule