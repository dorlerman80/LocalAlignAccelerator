/*------------------------------------------------------------------------------
 * File          : flipflop.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Sep 19, 2023
 * Description   : Flipflop Test Unit
 *------------------------------------------------------------------------------*/

module flipflop #()
(
	input logic clk,
	input logic rst_n,
	input logic flipflop_in,
	output logic flipflop_out
);

always_ff @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		flipflop_out <= 1'b0;
	end
	else begin
		flipflop_out <= flipflop_in;
	end
end

endmodule