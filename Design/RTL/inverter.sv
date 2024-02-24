/*------------------------------------------------------------------------------
 * File          : inverter.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Sep 19, 2023
 * Description   : Inverter Test Unit
 *------------------------------------------------------------------------------*/

module inverter #()
(
	input logic inverter_in,
	output logic inverter_out
);

assign inverter_out = ~inverter_in;

endmodule