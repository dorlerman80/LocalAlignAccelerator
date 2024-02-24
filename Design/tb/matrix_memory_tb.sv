/*------------------------------------------------------------------------------
 * File          : matrix_memory_tb.sv
 * Project       : RTL
 * Author        : epnido
 * Creation date : Jun 11, 2023
 * Description   : Matrix Memory's Testbench
 *------------------------------------------------------------------------------*/

`include "/users/epnido/Project/design/work/Project_Modules/RTL/design_variables.vh"

module matrix_memory_tb;
import design_variables::*;

// Inputs
logic clk;
logic rst_n;
logic [NUM_DIAGONALS-1:0] write_ctl;
logic [NUM_DIAGONALS_W-1:0] choose_diagonal;
logic [NUM_PU_MAIN_DIAGONAL_W-1:0] choose_pu;
logic [NUM_PE_IN_PU_W-1:0] choose_pe;
logic [NUM_PU_MAIN_DIAGONAL-1:0][1:0][1:0][DATA_PACKET_SIZE-1:0] data_packet_in;

// Outputs
logic [DATA_PACKET_SIZE-1:0] data_packet_out;

// Instantiate the design under test
matrix_memory #()
dut (
  .clk(clk),
  .rst_n(rst_n),
  .write_ctl(write_ctl),
  .choose_diagonal(choose_diagonal),
  .choose_pu(choose_pu),
  .choose_pe(choose_pe),
  .data_packet_in(data_packet_in),
  .data_packet_out(data_packet_out)
);

// Clock generation
always begin
	#5 clk = ~clk;
end

initial begin
  // Initialize inputs
  clk = 0;
  write_ctl = 31'b0;
  choose_diagonal = '0;
  choose_pu = '0;
  choose_pe = 0;
  
  // Reset
  rst_n = 0;
  #10;
  rst_n = 1;
  
  // Write data
  write_ctl[0] = 1;
  data_packet_in[0] = 12'd1899;
  #10;
  write_ctl[0] = 0;
  
  write_ctl[1] = 1;
  data_packet_in[1:0] = {12'd785,12'd3666};
  #10;
  write_ctl[1] = 0;
  
  write_ctl[2] = 1;
  data_packet_in[2:0] = {12'd560,12'd42,12'd3076};
  #10;
  write_ctl[2] = 0;
  
  write_ctl[3] = 1;
  data_packet_in[3:0] = {12'd2082,12'd1806,12'd402,12'd485};
  #10;
  write_ctl[3] = 0;
  /*
  write_ctl = 5'd4;
  data_packet_in[4:0] = {12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd5;
  data_packet_in[5:0] = {12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd6;
  data_packet_in[6:0] = {12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd7;
  data_packet_in[7:0] = {12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd8;
  data_packet_in[8:0] = {12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd9;
  data_packet_in[9:0] = {12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd10;
  data_packet_in[10:0] = {12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd11;
  data_packet_in[11:0] = {12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd12;
  data_packet_in[12:0] = {12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd13;
  data_packet_in[13:0] = {12'd53,12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd14;
  data_packet_in[14:0] = {12'd23,12'd53,12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd15;
  data_packet_in[15:0] = {12'd26,12'd23,12'd53,12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd16;
  data_packet_in[14:0] = {12'd23,12'd53,12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd17;
  data_packet_in[13:0] = {12'd53,12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd18;
  data_packet_in[12:0] = {12'd53,12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd19;
  data_packet_in[11:0] = {12'd82,
		  12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd20;
  data_packet_in[10:0] = {12'd56,12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd21;
  data_packet_in[9:0] = {12'd23,12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd22;
  data_packet_in[8:0] = {12'd53,12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd23;
  data_packet_in[7:0] = {12'd53,12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd24;
  data_packet_in[6:0] = {12'd82,
		  12'd11,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd25;
  data_packet_in[5:0] = {12'd82,12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd26;
  data_packet_in[4:0] = {12'd31,12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd27;
  data_packet_in[3:0] = {12'd22,12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd28;
  data_packet_in[2:0] = {12'd56,12'd42,12'd36};
  #10;
  
  write_ctl = 5'd29;
  data_packet_in[1:0] = {12'd42,12'd36};
  #10;
  
  write_ctl = 5'd30;
  data_packet_in[0] = 12'd36;
  #10;
  */
   
  // Read data
  choose_diagonal = 0;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  
  choose_diagonal = 1;
  choose_pu = 1;
  choose_pe = 1;
  #10;
  
  choose_diagonal = 2;
  choose_pu = 2;
  choose_pe = 2;
  #10;
  
  choose_diagonal = 3;
  choose_pu = 3;
  choose_pe = 3;
  #10;
  
  
  /*
  choose_diagonal = 4;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 5;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 6;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 7;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 8;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 9;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 10;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 11;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 12;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 13;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 14;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 15;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 16;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 17;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 18;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 19;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 20;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 21;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 22;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 23;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 24;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 25;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 26;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 27;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 28;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 29;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  
  choose_diagonal = 30;
  choose_pu = 0;
  choose_pe = 0;
  #10;
  */
  
  // End simulation
  $finish;
end

endmodule