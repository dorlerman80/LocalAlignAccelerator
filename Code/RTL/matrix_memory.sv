/*------------------------------------------------------------------------------
 * File          : matrix_memory.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Apr 10, 2023
 * Description   : Stores the required data of the matrix
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"
module matrix_memory
import design_variables::*;
/*==============================PARAMS===============================*/
#(
	// Defined in design_variables package
)
/*==============================IN/OUT===============================*/
(
	// CLK & RESET
	input logic 	clk,
	input logic 	rst_n,
	
	// Controller Interface
	input logic [NUM_DIAGONALS-1:0]				write_ctl,			// Enables vector
	input logic [NUM_DIAGONALS_W-1:0] 		    choose_diagonal,	// Select diagonal to read
	input logic [NUM_PU_MAIN_DIAGONAL_W-1:0]  	choose_pu,			// Select PU to read
	input logic [NUM_PE_IN_PU_W-1:0]			choose_pe,			// Select PE to read
	
	// Write Interface
	input logic [NUM_PU_MAIN_DIAGONAL-1:0][1:0][1:0][DATA_PACKET_SIZE-1:0]	data_packet_in,
	
	// Read Interface
	output logic [DATA_PACKET_SIZE-1:0]  data_packet_out
);

/*===============================LOGIC===============================*/
logic 	   [1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_0;
logic [1:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_1;
logic [2:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_2;
logic [3:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_3;
logic [4:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_4;
logic [5:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_5;
logic [6:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_6;
logic [7:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_7;
logic [8:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_8;
logic [9:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_9;
logic [10:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_10;
logic [11:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_11;
logic [12:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_12;
logic [13:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_13;
logic [14:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_14;
logic [15:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_15;
logic [14:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_16;
logic [13:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_17;
logic [12:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_18;
logic [11:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_19;
logic [10:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_20;
logic [9:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_21;
logic [8:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_22;
logic [7:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_23;
logic [6:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_24;
logic [5:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_25;
logic [4:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_26;
logic [3:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_27;
logic [2:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_28;
logic [1:0][1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_29;
logic 	   [1:0][1:0][DATA_PACKET_SIZE-1:0] diagonal_30;

// Diagonal 0
generate
	for (genvar i = 0; i < 2; i++) begin : diagonal_0_pe_rows
		for (genvar j = 0; j < 2; j++) begin : diagonal_0_pe_cols
			always_ff @(posedge clk or negedge rst_n) begin
				if (!rst_n) begin
					diagonal_0[i][j] <= '0;
				end
				else begin
					if (write_ctl[0])
						diagonal_0[i][j] <= data_packet_in[0][i][j];
				end
			end
		end
	end
endgenerate

// Diagonal 1
generate
	for (genvar k = 0; k <= 1; k++) begin : diagonal_1_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_1[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[1])
							diagonal_1[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 2
generate
	for (genvar k = 0; k <= 2; k++) begin : diagonal_2_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_2[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[2])
							diagonal_2[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 3
generate
	for (genvar k = 0; k <= 3; k++) begin : diagonal_3_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_3[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[3])
							diagonal_3[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 4
generate
	for (genvar k = 0; k <= 4; k++) begin : diagonal_4_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_4[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[4])
							diagonal_4[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 5
generate
	for (genvar k = 0; k <= 5; k++) begin : diagonal_5_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_5[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[5])
							diagonal_5[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 6
generate
	for (genvar k = 0; k <= 6; k++) begin : diagonal_6_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_6[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[6])
							diagonal_6[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 7
generate
	for (genvar k = 0; k <= 7; k++) begin : diagonal_7_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_7[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[7])
							diagonal_7[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 8
generate
	for (genvar k = 0; k <= 8; k++) begin : diagonal_8_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_8[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[8])
							diagonal_8[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 9
generate
	for (genvar k = 0; k <= 9; k++) begin : diagonal_9_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_9[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[9])
							diagonal_9[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 10
generate
	for (genvar k = 0; k <= 10; k++) begin : diagonal_10_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_10[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[10])
							diagonal_10[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 11
generate
	for (genvar k = 0; k <= 11; k++) begin : diagonal_11_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_11[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[11])
							diagonal_11[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 12
generate
	for (genvar k = 0; k <= 12; k++) begin : diagonal_12_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_12[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[12])
							diagonal_12[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 13
generate
	for (genvar k = 0; k <= 13; k++) begin : diagonal_13_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_13[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[13])
							diagonal_13[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 14
generate
	for (genvar k = 0; k <= 14; k++) begin : diagonal_14_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_14[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[14])
							diagonal_14[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 15
generate
	for (genvar k = 0; k <= 15; k++) begin : diagonal_15_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_15[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[15])
							diagonal_15[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 16
generate
	for (genvar k = 0; k <= 14; k++) begin : diagonal_16_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_16[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[16])
							diagonal_16[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 17
generate
	for (genvar k = 0; k <= 13; k++) begin : diagonal_17_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_17[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[17])
							diagonal_17[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 18
generate
	for (genvar k = 0; k <= 12; k++) begin : diagonal_18_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_18[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[18])
							diagonal_18[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 19
generate
	for (genvar k = 0; k <= 11; k++) begin : diagonal_19_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_19[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[19])
							diagonal_19[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 20
generate
	for (genvar k = 0; k <= 10; k++) begin : diagonal_20_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_20[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[20])
							diagonal_20[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 21
generate
	for (genvar k = 0; k <= 9; k++) begin : diagonal_21_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_21[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[21])
							diagonal_21[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 22
generate
	for (genvar k = 0; k <= 8; k++) begin : diagonal_22_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_22[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[22])
							diagonal_22[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 23
generate
	for (genvar k = 0; k <= 7; k++) begin : diagonal_23_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_23[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[23])
							diagonal_23[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 24
generate
	for (genvar k = 0; k <= 6; k++) begin : diagonal_24_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_24[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[24])
							diagonal_24[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 25
generate
	for (genvar k = 0; k <= 5; k++) begin : diagonal_25_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_25[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[25])
							diagonal_25[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 26
generate
	for (genvar k = 0; k <= 4; k++) begin : diagonal_26_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_26[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[26])
							diagonal_26[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 27
generate
	for (genvar k = 0; k <= 3; k++) begin : diagonal_27_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_27[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[27])
							diagonal_27[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 28
generate
	for (genvar k = 0; k <= 2; k++) begin : diagonal_28_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_28[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[28])
							diagonal_28[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 29
generate
	for (genvar k = 0; k <= 1; k++) begin : diagonal_29_cells
		for (genvar i = 0; i < 2; i++) begin : pe_rows
			for (genvar j = 0; j < 2; j++) begin : pe_cols
				always_ff @(posedge clk or negedge rst_n) begin
					if (!rst_n) begin
						diagonal_29[k][i][j] <= '0;
					end
					else begin
						if (write_ctl[29])
							diagonal_29[k][i][j] <= data_packet_in[k][i][j];
					end
				end
			end
		end
	end
endgenerate

// Diagonal 30
generate
	for (genvar i = 0; i < 2; i++) begin : diagonal_30_pe_rows
		for (genvar j = 0; j < 2; j++) begin : diagonal_30_pe_cols
			always_ff @(posedge clk or negedge rst_n) begin
				if (!rst_n) begin
					diagonal_30[i][j] <= '0;
				end
				else begin
					if (write_ctl[30])
						diagonal_30[i][j] <= data_packet_in[0][i][j];
				end
			end
		end
	end
endgenerate

// Read from Memory
logic [NUM_PU_MAIN_DIAGONAL-1:0][1:0][1:0][DATA_PACKET_SIZE-1:0] selected_diagonal;
logic [1:0][1:0][DATA_PACKET_SIZE-1:0] selected_pu;
logic [DATA_PACKET_SIZE-1:0] selected_pe;

always_comb begin
	selected_diagonal = '0;
	case (choose_diagonal)
		5'd0: selected_diagonal[0] = diagonal_0;
		5'd1: selected_diagonal[1:0] = diagonal_1;
		5'd2: selected_diagonal[2:0] = diagonal_2;
		5'd3: selected_diagonal[3:0] = diagonal_3;
		5'd4: selected_diagonal[4:0] = diagonal_4;
		5'd5: selected_diagonal[5:0] = diagonal_5;
		5'd6: selected_diagonal[6:0] = diagonal_6;
		5'd7: selected_diagonal[7:0] = diagonal_7;
		5'd8: selected_diagonal[8:0] = diagonal_8;
		5'd9: selected_diagonal[9:0] = diagonal_9;
		5'd10: selected_diagonal[10:0] = diagonal_10;
		5'd11: selected_diagonal[11:0] = diagonal_11;
		5'd12: selected_diagonal[12:0] = diagonal_12;
		5'd13: selected_diagonal[13:0] = diagonal_13;
		5'd14: selected_diagonal[14:0] = diagonal_14;
		5'd15: selected_diagonal[15:0] = diagonal_15;
		5'd16: selected_diagonal[14:0] = diagonal_16;
		5'd17: selected_diagonal[13:0] = diagonal_17;
		5'd18: selected_diagonal[12:0] = diagonal_18;
		5'd19: selected_diagonal[11:0] = diagonal_19;
		5'd20: selected_diagonal[10:0] = diagonal_20;
		5'd21: selected_diagonal[9:0] = diagonal_21;
		5'd22: selected_diagonal[8:0] = diagonal_22;
		5'd23: selected_diagonal[7:0] = diagonal_23;
		5'd24: selected_diagonal[6:0] = diagonal_24;
		5'd25: selected_diagonal[5:0] = diagonal_25;
		5'd26: selected_diagonal[4:0] = diagonal_26;
		5'd27: selected_diagonal[3:0] = diagonal_27;
		5'd28: selected_diagonal[2:0] = diagonal_28;
		5'd29: selected_diagonal[1:0] = diagonal_29;
		5'd30: selected_diagonal[0] = diagonal_30;
		default: selected_diagonal = '0;
	endcase
end

assign selected_pu = selected_diagonal[choose_pu];

always_comb begin
	case (choose_pe)
		2'd0: selected_pe = selected_pu[0][0];
		2'd1: selected_pe = selected_pu[0][1];
		2'd2: selected_pe = selected_pu[1][0];
		2'd3: selected_pe = selected_pu[1][1];
		default: selected_pe = selected_pu[0][0];
	endcase
end

assign data_packet_out = selected_pe;

endmodule
