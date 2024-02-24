/*------------------------------------------------------------------------------
 * File          : controller_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Sep 6, 2023
 * Description   : Controller's Testbench
 *------------------------------------------------------------------------------*/

module controller_tb;

localparam SEQ_LENGTH         =    32;
localparam NUM_REG      		 = 	  8;
localparam NUM_PU 	         =    16;
localparam NUM_ROWS_COLS      =    1;
localparam NUM_VALUES_TO_SEL  =    48; // CHECK IF IT IS 48!!!!!!
		
localparam NUM_DIAGONALS 	= 31;
localparam NUM_PE_IN_PU		= 4;
localparam DIAGONAL_LENGTH 	= 16;
		
localparam NUM_DIRECTIONS 	= 3;
		
localparam SEQUENCE_LEN 		= 32;

// Inputs
logic clk;
logic rst_n;
logic vld_alignment;
logic [$clog2(SEQUENCE_LEN)-1:0] next_row;
logic [$clog2(SEQUENCE_LEN)-1:0] next_col;
logic finished;

// Outputs
logic wr_en_buff;
logic [$clog2(NUM_REG)-1:0] count_buff;
logic wr_en_max; 
logic [NUM_PU-2:0][1:0] top_sel;
logic [NUM_PU-2:0][1:0] left_sel;
logic [NUM_PU-2:0][1:0] diagonal_sel;
logic [NUM_PU-1:0][NUM_ROWS_COLS:0][$clog2(SEQ_LENGTH)-1:0] query_letter_sel;
logic [NUM_PU-1:0][NUM_ROWS_COLS:0][$clog2(SEQ_LENGTH)-1:0] database_letter_sel;
logic [NUM_DIAGONALS-1:0] write_ctl;
logic [$clog2(NUM_DIAGONALS)-1:0] choose_diagonal;
logic [$clog2(DIAGONAL_LENGTH)-1:0] choose_pu;
logic [$clog2(NUM_PE_IN_PU)-1:0] choose_pe;
logic en_traceback;
logic start_of_traceback;
logic rdy_alignment;

// Instantiate the controller module
controller #(
  // ... Pass localparam values as needed ...
) controller_inst (
	.clk(clk),
	.rst_n(rst_n),
	.next_row(next_row),
	.next_col(next_col),
	.finished(finished),
	.wr_en_buff(wr_en_buff),
	.count_buff(count_buff),
	.wr_en_max(wr_en_max),
	.top_sel(top_sel),
	.left_sel(left_sel),
	.diagonal_sel(diagonal_sel),
	.query_letter_sel(query_letter_sel),
	.database_letter_sel(database_letter_sel),
	.write_ctl(write_ctl),
	.choose_diagonal(choose_diagonal),
	.choose_pu(choose_pu),
	.choose_pe(choose_pe),
	.en_traceback(en_traceback),
	.start_of_traceback(start_of_traceback)
  );


// Testbench initialization
initial begin
	
  clk = 1'b0;
  rst_n = 1'b0;
  next_row = 5'd0;
  next_col = 5'd0;
  finished = 1'b0;
  vld_alignment = 1'b0;
  
  @(posedge clk);
  rst_n = 1'b1;
  
  @(posedge clk);
  vld_alignment = 1'b1;
  
  @(posedge clk);
  vld_alignment = 1'b0;

  #600
  finished = 1'b1;
  
  // Finish simulation after some time
  #1000;
  $finish;
end

always begin
	#5 clk = ~clk;
end

// Monitor s or add assertions as needed
// Example assertion:
// assert(wr_en_buff == 1'b1) else $display("wr_en_buff assertion failed");

endmodule