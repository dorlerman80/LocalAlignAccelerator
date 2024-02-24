/*------------------------------------------------------------------------------
 * File          : max.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 6, 2023
 * Description   : Maximum Computation Unit.
 *				   Computes the maximum value for a single processing element (left, top and diagonal neighbored cells).
 *------------------------------------------------------------------------------*/

`include "./design_variables.vh"

module max
import design_variables::*;
#()

/*==============================IN/OUT===============================*/
(
	input logic [SCORE_WIDTH_MAX-1:0]      top,
	input logic [SCORE_WIDTH_MAX-1:0]      left,
	input logic [SCORE_WIDTH_MAX-1:0]      diagonal,

	output logic [SCORE_WIDTH_MAX-1:0]     max,
	output logic [1:0]           	   	   source // '00' - diagonal, '01' - left, '10' - diagonal, '11' - top
);

/*==============================SIGNALS==============================*/
logic [SCORE_WIDTH_MAX-1:0]	max_top_left;
logic [SCORE_WIDTH_MAX-1:0] max_diagonal_zero;
 
logic 						s0;
logic						s1;
logic						s2;

/*===============================LOGIC===============================*/
assign s0 = (diagonal >= {SCORE_WIDTH_MAX{1'b0}}) ? 1'b0 : 1'b1;
assign max_diagonal_zero = (s0) ? {SCORE_WIDTH_MAX{1'b0}} : diagonal;

assign s1 = (left >= top) ? 1'b0 : 1'b1;
assign max_top_left = (s1) ? top : left;

assign s2 = (max_diagonal_zero >= max_top_left) ? 1'b0 : 1'b1;
assign max = (s2) ? max_top_left : max_diagonal_zero;

assign source[0] = s2;
assign source[1] = s1;

endmodule
