/*------------------------------------------------------------------------------
 * File          : max_of_n_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : May 27, 2023
 * Description   :
 *------------------------------------------------------------------------------*/

module max_of_n_tb;

// Parameters
localparam N = 4;
localparam SCORE_BITS_WIDTH = 8;
localparam ROW_BITS_WIDTH = 5;
localparam COL_BITS_WIDTH = 5;

// Inputs
logic [N-1:0][SCORE_BITS_WIDTH-1:0] score_in;
logic [N-1:0][ROW_BITS_WIDTH-1:0] row_in;
logic [N-1:0][COL_BITS_WIDTH-1:0] col_in;

// Outputs
logic [SCORE_BITS_WIDTH-1:0] max_n_score;
logic [ROW_BITS_WIDTH-1:0] max_n_row;
logic [COL_BITS_WIDTH-1:0] max_n_col;

// Instantiate the module under test
max_of_n #(
	/*
  .N(N),
  .SCORE_BITS_WIDTH(SCORE_BITS_WIDTH),
  .ROW_BITS_WIDTH(ROW_BITS_WIDTH),
  .COL_BITS_WIDTH(COL_BITS_WIDTH)
  */
) dut (
  .score_in(score_in),
  .row_in(row_in),
  .col_in(col_in),
  .max_n_score(max_n_score),
  .max_n_row(max_n_row),
  .max_n_col(max_n_col)
);

// Generate stimulus
initial begin
  // Initialize inputs
  score_in[0] = 8'd127;
  row_in[0] = 5'd0;
  col_in[0] = 5'd0;
  score_in[1] = 8'd128;
  row_in[1] = 5'd0;
  col_in[1] = 5'd1;
  score_in[2] = 8'd110;
  row_in[2] = 5'd1;
  col_in[2] = 5'd0;
  score_in[3] = 8'd2;
  row_in[3] = 5'd1;
  col_in[3] = 5'd1;

  #10;

  score_in[0] = 8'd9;
  row_in[0] = 5'd0;
  col_in[0] = 5'd2;
  score_in[1] = 8'd18;
  row_in[1] = 5'd0;
  col_in[1] = 5'd3;
  score_in[2] = 8'd18;
  row_in[2] = 5'd1;
  col_in[2] = 5'd2;
  score_in[3] = 8'd0;
  row_in[3] = 5'd1;
  col_in[3] = 5'd3;
  
  #10;

  // End the simulation
  $finish;
end

endmodule