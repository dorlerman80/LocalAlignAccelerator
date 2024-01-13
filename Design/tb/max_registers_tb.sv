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
	clk = 0;
	rst_n = 0;
	wr_en_max = 0;
	score_in = '0;
	row_in = '0;
	col_in = '0;

	#10
	
	rst_n = 1; // Release reset
	wr_en_max = 1;

	// Test case 1
	score_in[0][0] = 8'd1;
	score_in[0][1] = 8'd8;
	score_in[0][2] = 8'd13;
	score_in[0][3] = 8'd3;
	row_in[0][0] = 5'd0;
	row_in[0][1] = 5'd0;
	row_in[0][2] = 5'd1;
	row_in[0][3] = 5'd1;
	col_in[0][0] = 5'd0;
	col_in[0][1] = 5'd1;
	col_in[0][2] = 5'd0;
	col_in[0][3] = 5'd1;

	score_in[1][0] = 8'd5;
	score_in[1][1] = 8'd11;
	score_in[1][2] = 8'd3;
	score_in[1][3] = 8'd8;
	row_in[1][0] = 5'd29;
	row_in[1][1] = 5'd16;
	row_in[1][2] = 5'd9;
	row_in[1][3] = 5'd23;
	col_in[1][0] = 5'd4;
	col_in[1][1] = 5'd7;
	col_in[1][2] = 5'd27;
	col_in[1][3] = 5'd11;

	score_in[2][0] = 8'd8;
	score_in[2][1] = 8'd1;
	score_in[2][2] = 8'd7;
	score_in[2][3] = 8'd4;
	row_in[2][0] = 5'd7;
	row_in[2][1] = 5'd8;
	row_in[2][2] = 5'd15;
	row_in[2][3] = 5'd29;
	col_in[2][0] = 5'd12;
	col_in[2][1] = 5'd23;
	col_in[2][2] = 5'd1;
	col_in[2][3] = 5'd18;

	score_in[3][0] = 8'd3;
	score_in[3][1] = 8'd9;
	score_in[3][2] = 8'd4;
	score_in[3][3] = 8'd7;
	row_in[3][0] = 5'd30;
	row_in[3][1] = 5'd3;
	row_in[3][2] = 5'd20;
	row_in[3][3] = 5'd28;
	col_in[3][0] = 5'd24;
	col_in[3][1] = 5'd2;
	col_in[3][2] = 5'd9;
	col_in[3][3] = 5'd17;

//	score_in[4][0] = 8'd9;
//	score_in[4][1] = 8'd42;
//	score_in[4][2] = 8'd104;
//	score_in[4][3] = 8'd78;
//	row_in[4][0] = 5'd0;
//	row_in[4][1] = 5'd30;
//	row_in[4][2] = 5'd28;
//	row_in[4][3] = 5'd7;
//	col_in[4][0] = 5'd10;
//	col_in[4][1] = 5'd5;
//	col_in[4][2] = 5'd20;
//	col_in[4][3] = 5'd1;
//
//	score_in[5][0] = 8'd101;
//	score_in[5][1] = 8'd59;
//	score_in[5][2] = 8'd33;
//	score_in[5][3] = 8'd6;
//	row_in[5][0] = 5'd3;
//	row_in[5][1] = 5'd1;
//	row_in[5][2] = 5'd29;
//	row_in[5][3] = 5'd28;
//	col_in[5][0] = 5'd19;
//	col_in[5][1] = 5'd4;
//	col_in[5][2] = 5'd22;
//	col_in[5][3] = 5'd20;
//
//	score_in[6][0] = 8'd3;
//	score_in[6][1] = 8'd76;
//	score_in[6][2] = 8'd119;
//	score_in[6][3] = 8'd54;
//	row_in[6][0] = 5'd13;
//	row_in[6][1] = 5'd27;
//	row_in[6][2] = 5'd10;
//	row_in[6][3] = 5'd2;
//	col_in[6][0] = 5'd27;
//	col_in[6][1] = 5'd30;
//	col_in[6][2] = 5'd7;
//	col_in[6][3] = 5'd3;
//
//	score_in[7][0] = 8'd88;
//	score_in[7][1] = 8'd19;
//	score_in[7][2] = 8'd64;
//	score_in[7][3] = 8'd12;
//	row_in[7][0] = 5'd23;
//	row_in[7][1] = 5'd14;
//	row_in[7][2] = 5'd27;
//	row_in[7][3] = 5'd4;
//	col_in[7][0] = 5'd11;
//	col_in[7][1] = 5'd8;
//	col_in[7][2] = 5'd1;
//	col_in[7][3] = 5'd21;
//
//	score_in[8][0] = 8'd18;
//	score_in[8][1] = 8'd84;
//	score_in[8][2] = 8'd7;
//	score_in[8][3] = 8'd101;
//	row_in[8][0] = 5'd8;
//	row_in[8][1] = 5'd23;
//	row_in[8][2] = 5'd29;
//	row_in[8][3] = 5'd12;
//	col_in[8][0] = 5'd17;
//	col_in[8][1] = 5'd1;
//	col_in[8][2] = 5'd15;
//	col_in[8][3] = 5'd9;
//
//	score_in[9][0] = 8'd73;
//	score_in[9][1] = 8'd29;
//	score_in[9][2] = 8'd111;
//	score_in[9][3] = 8'd36;
//	row_in[9][0] = 5'd30;
//	row_in[9][1] = 5'd13;
//	row_in[9][2] = 5'd3;
//	row_in[9][3] = 5'd6;
//	col_in[9][0] = 5'd22;
//	col_in[9][1] = 5'd29;
//	col_in[9][2] = 5'd16;
//	col_in[9][3] = 5'd5;
//
//	score_in[10][0] = 8'd45;
//	score_in[10][1] = 8'd76;
//	score_in[10][2] = 8'd28;
//	score_in[10][3] = 8'd98;
//	row_in[10][0] = 5'd3;
//	row_in[10][1] = 5'd0;
//	row_in[10][2] = 5'd8;
//	row_in[10][3] = 5'd21;
//	col_in[10][0] = 5'd1;
//	col_in[10][1] = 5'd9;
//	col_in[10][2] = 5'd27;
//	col_in[10][3] = 5'd30;
//
//	score_in[11][0] = 8'd95;
//	score_in[11][1] = 8'd64;
//	score_in[11][2] = 8'd13;
//	score_in[11][3] = 8'd57;
//	row_in[11][0] = 5'd29;
//	row_in[11][1] = 5'd4;
//	row_in[11][2] = 5'd13;
//	row_in[11][3] = 5'd6;
//	col_in[11][0] = 5'd5;
//	col_in[11][1] = 5'd25;
//	col_in[11][2] = 5'd8;
//	col_in[11][3] = 5'd22;
//
//	score_in[12][0] = 8'd76;
//	score_in[12][1] = 8'd113;
//	score_in[12][2] = 8'd84;
//	score_in[12][3] = 8'd28;
//	row_in[12][0] = 5'd2;
//	row_in[12][1] = 5'd20;
//	row_in[12][2] = 5'd6;
//	row_in[12][3] = 5'd7;
//	col_in[12][0] = 5'd30;
//	col_in[12][1] = 5'd8;
//	col_in[12][2] = 5'd21;
//	col_in[12][3] = 5'd19;
//
//	score_in[13][0] = 8'd45;
//	score_in[13][1] = 8'd8;
//	score_in[13][2] = 8'd110;
//	score_in[13][3] = 8'd72;
//	row_in[13][0] = 5'd27;
//	row_in[13][1] = 5'd6;
//	row_in[13][2] = 5'd0;
//	row_in[13][3] = 5'd23;
//	col_in[13][0] = 5'd30;
//	col_in[13][1] = 5'd17;
//	col_in[13][2] = 5'd3;
//	col_in[13][3] = 5'd19;
//
//	score_in[14][0] = 8'd97;
//	score_in[14][1] = 8'd28;
//	score_in[14][2] = 8'd78;
//	score_in[14][3] = 8'd12;
//	row_in[14][0] = 5'd14;
//	row_in[14][1] = 5'd23;
//	row_in[14][2] = 5'd0;
//	row_in[14][3] = 5'd30;
//	col_in[14][0] = 5'd1;
//	col_in[14][1] = 5'd29;
//	col_in[14][2] = 5'd6;
//	col_in[14][3] = 5'd10;
//
//	score_in[15][0] = 8'd85;
//	score_in[15][1] = 8'd57;
//	score_in[15][2] = 8'd14;
//	score_in[15][3] = 8'd120;
//	row_in[15][0] = 5'd29;
//	row_in[15][1] = 5'd23;
//	row_in[15][2] = 5'd3;
//	row_in[15][3] = 5'd6;
//	col_in[15][0] = 5'd11;
//	col_in[15][1] = 5'd21;
//	col_in[15][2] = 5'd25;
//	col_in[15][3] = 5'd30;
//
	#10
			
	// Test Case 2
	score_in[0][0] = 8'd2;
	score_in[0][1] = 8'd7;
	score_in[0][2] = 8'd12;
	score_in[0][3] = 8'd5;
	row_in[0][0] = 5'd1;
	row_in[0][1] = 5'd0;
	row_in[0][2] = 5'd0;
	row_in[0][3] = 5'd1;
	col_in[0][0] = 5'd0;
	col_in[0][1] = 5'd0;
	col_in[0][2] = 5'd0;
	col_in[0][3] = 5'd1;

	score_in[1][0] = 8'd4;
	score_in[1][1] = 8'd8;
	score_in[1][2] = 8'd8;
	score_in[1][3] = 8'd4;
	row_in[1][0] = 5'd26;
	row_in[1][1] = 5'd6;
	row_in[1][2] = 5'd13;
	row_in[1][3] = 5'd10;
	col_in[1][0] = 5'd20;
	col_in[1][1] = 5'd19;
	col_in[1][2] = 5'd5;
	col_in[1][3] = 5'd24;

	score_in[2][0] = 8'd7;
	score_in[2][1] = 8'd11;
	score_in[2][2] = 8'd1;
	score_in[2][3] = 8'd15;
	row_in[2][0] = 5'd8;
	row_in[2][1] = 5'd27;
	row_in[2][2] = 5'd13;
	row_in[2][3] = 5'd6;
	col_in[2][0] = 5'd21;
	col_in[2][1] = 5'd17;
	col_in[2][2] = 5'd15;
	col_in[2][3] = 5'd1;

	score_in[3][0] = 8'd3;
	score_in[3][1] = 8'd4;
	score_in[3][2] = 8'd9;
	score_in[3][3] = 8'd7;
	row_in[3][0] = 5'd30;
	row_in[3][1] = 5'd9;
	row_in[3][2] = 5'd3;
	row_in[3][3] = 5'd20;
	col_in[3][0] = 5'd24;
	col_in[3][1] = 5'd9;
	col_in[3][2] = 5'd2;
	col_in[3][3] = 5'd9;

//	score_in[4][0] = 8'd9;
//	score_in[4][1] = 8'd104;
//	score_in[4][2] = 8'd42;
//	score_in[4][3] = 8'd78;
//	row_in[4][0] = 5'd0;
//	row_in[4][1] = 5'd28;
//	row_in[4][2] = 5'd30;
//	row_in[4][3] = 5'd2;
//	col_in[4][0] = 5'd16;
//	col_in[4][1] = 5'd30;
//	col_in[4][2] = 5'd10;
//	col_in[4][3] = 5'd14;
//
//	score_in[5][0] = 8'd63;
//	score_in[5][1] = 8'd82;
//	score_in[5][2] = 8'd19;
//	score_in[5][3] = 8'd110;
//	row_in[5][0] = 5'd1;
//	row_in[5][1] = 5'd9;
//	row_in[5][2] = 5'd30;
//	row_in[5][3] = 5'd28;
//	col_in[5][0] = 5'd10;
//	col_in[5][1] = 5'd7;
//	col_in[5][2] = 5'd6;
//	col_in[5][3] = 5'd13;
//
//	score_in[6][0] = 8'd115;
//	score_in[6][1] = 8'd18;
//	score_in[6][2] = 8'd7;
//	score_in[6][3] = 8'd91;
//	row_in[6][0] = 5'd0;
//	row_in[6][1] = 5'd29;
//	row_in[6][2] = 5'd20;
//	row_in[6][3] = 5'd23;
//	col_in[6][0] = 5'd11;
//	col_in[6][1] = 5'd16;
//	col_in[6][2] = 5'd24;
//	col_in[6][3] = 5'd27;
//
//	score_in[7][0] = 8'd49;
//	score_in[7][1] = 8'd84;
//	score_in[7][2] = 8'd7;
//	score_in[7][3] = 8'd99;
//	row_in[7][0] = 5'd13;
//	row_in[7][1] = 5'd19;
//	row_in[7][2] = 5'd1;
//	row_in[7][3] = 5'd2;
//	col_in[7][0] = 5'd22;
//	col_in[7][1] = 5'd20;
//	col_in[7][2] = 5'd30;
//	col_in[7][3] = 5'd24;
//
//	score_in[8][0] = 8'd103;
//	score_in[8][1] = 8'd7;
//	score_in[8][2] = 8'd120;
//	score_in[8][3] = 8'd58;
//	row_in[8][0] = 5'd1;
//	row_in[8][1] = 5'd0;
//	row_in[8][2] = 5'd0;
//	row_in[8][3] = 5'd1;
//	col_in[8][0] = 5'd0;
//	col_in[8][1] = 5'd0;
//	col_in[8][2] = 5'd0;
//	col_in[8][3] = 5'd1;
//
//	score_in[9][0] = 8'd24;
//	score_in[9][1] = 8'd88;
//	score_in[9][2] = 8'd18;
//	score_in[9][3] = 8'd34;
//	row_in[9][0] = 5'd26;
//	row_in[9][1] = 5'd6;
//	row_in[9][2] = 5'd13;
//	row_in[9][3] = 5'd10;
//	col_in[9][0] = 5'd20;
//	col_in[9][1] = 5'd19;
//	col_in[9][2] = 5'd5;
//	col_in[9][3] = 5'd24;
//
//	score_in[10][0] = 8'd70;
//	score_in[10][1] = 8'd45;
//	score_in[10][2] = 8'd11;
//	score_in[10][3] = 8'd84;
//	row_in[10][0] = 5'd8;
//	row_in[10][1] = 5'd27;
//	row_in[10][2] = 5'd13;
//	row_in[10][3] = 5'd6;
//	col_in[10][0] = 5'd21;
//	col_in[10][1] = 5'd17;
//	col_in[10][2] = 5'd15;
//	col_in[10][3] = 5'd1;
//
//	score_in[11][0] = 8'd31;
//	score_in[11][1] = 8'd4;
//	score_in[11][2] = 8'd92;
//	score_in[11][3] = 8'd77;
//	row_in[11][0] = 5'd30;
//	row_in[11][1] = 5'd9;
//	row_in[11][2] = 5'd3;
//	row_in[11][3] = 5'd20;
//	col_in[11][0] = 5'd24;
//	col_in[11][1] = 5'd9;
//	col_in[11][2] = 5'd2;
//	col_in[11][3] = 5'd9;
//
//	score_in[12][0] = 8'd9;
//	score_in[12][1] = 8'd104;
//	score_in[12][2] = 8'd42;
//	score_in[12][3] = 8'd78;
//	row_in[12][0] = 5'd0;
//	row_in[12][1] = 5'd28;
//	row_in[12][2] = 5'd30;
//	row_in[12][3] = 5'd2;
//	col_in[12][0] = 5'd16;
//	col_in[12][1] = 5'd30;
//	col_in[12][2] = 5'd10;
//	col_in[12][3] = 5'd14;
//
//	score_in[13][0] = 8'd63;
//	score_in[13][1] = 8'd82;
//	score_in[13][2] = 8'd19;
//	score_in[13][3] = 8'd110;
//	row_in[13][0] = 5'd1;
//	row_in[13][1] = 5'd9;
//	row_in[13][2] = 5'd30;
//	row_in[13][3] = 5'd28;
//	col_in[13][0] = 5'd10;
//	col_in[13][1] = 5'd7;
//	col_in[13][2] = 5'd6;
//	col_in[13][3] = 5'd13;
//
//	score_in[14][0] = 8'd115;
//	score_in[14][1] = 8'd18;
//	score_in[14][2] = 8'd7;
//	score_in[14][3] = 8'd91;
//	row_in[14][0] = 5'd0;
//	row_in[14][1] = 5'd29;
//	row_in[14][2] = 5'd20;
//	row_in[14][3] = 5'd23;
//	col_in[14][0] = 5'd11;
//	col_in[14][1] = 5'd16;
//	col_in[14][2] = 5'd24;
//	col_in[14][3] = 5'd27;
//
//	score_in[15][0] = 8'd49;
//	score_in[15][1] = 8'd84;
//	score_in[15][2] = 8'd7;
//	score_in[15][3] = 8'd99;
//	row_in[15][0] = 5'd13;
//	row_in[15][1] = 5'd19;
//	row_in[15][2] = 5'd1;
//	row_in[15][3] = 5'd2;
//	col_in[15][0] = 5'd22;
//	col_in[15][1] = 5'd20;
//	col_in[15][2] = 5'd30;
//	col_in[15][3] = 5'd24;
			
	#10
			
	$finish; // End simulation
end

endmodule