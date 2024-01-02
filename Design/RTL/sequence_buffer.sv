/*------------------------------------------------------------------------------
 * File          : sequence_buffer.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 10, 2023
 * Description   : Loads 2 sequences into registers
 *------------------------------------------------------------------------------*/
`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module sequence_buffer
import design_variables::*; 
/*==============================PARAMS===============================*/
#(
	// Defined in design_variables package
)

/*==============================IN/OUT===============================*/
(
	// Clock & reset
	input logic                                 			clk,
	input logic                                 			rst_n,
	
	// Controller Interface
	input logic                                 			wr_en_buff,
	input logic  [BUFF_CNT_W-1:0]          					count,
	
	// Inputs
	input logic  [INPUT_WIDTH-1:0]              			query_seq_in,
	input logic  [INPUT_WIDTH-1:0]              			database_seq_in,
	
	// Outputs
	output logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0]			query_seq_out,
	output logic [SEQ_LENGTH-1:0][LETTER_WIDTH-1:0]			database_seq_out
);

/*===============================SIGNALS=============================*/

// Decoder
logic [NUM_BUFF_REGS-1:0] reg_enable;

// Query Registers
logic [NUM_BUFF_REGS-1:0][BITS_REG-1:0] query_regs;

// Database Registers
logic [NUM_BUFF_REGS-1:0][BITS_REG-1:0] database_regs;

/*===============================LOGIC===============================*/
// Decoder
always_comb begin
	for (int i = 0; i < NUM_BUFF_REGS; i++) begin : decoder
		reg_enable[i] = (i[BUFF_CNT_W-1:0] == count);
	end
end

// Query Registers
generate
	for (genvar i = 0; i < NUM_BUFF_REGS; i++) begin : query_reg
		always_ff @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				query_regs[i] <= '0;
			end
			
			else begin	
				if (reg_enable[i] && wr_en_buff) begin
					query_regs[i] <= query_seq_in;
				end
			end
		end
	end
endgenerate

// Database Registers
generate
	for (genvar i = 0; i < NUM_BUFF_REGS; i++) begin : database_reg
		always_ff @(posedge clk or negedge rst_n) begin
			if (!rst_n) begin
				database_regs[i] <= '0;
			end
			
			else begin
				if (reg_enable[i] && wr_en_buff) begin
					database_regs[i] <= database_seq_in;
				end
			end
		end
	end
endgenerate

// Output Wires to Matrix
assign query_seq_out = query_regs;
assign database_seq_out = database_regs;

endmodule
