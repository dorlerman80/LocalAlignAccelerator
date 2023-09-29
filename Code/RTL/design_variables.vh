/*------------------------------------------------------------------------------
 * File          : design_variables.vh
 * Project       : RTL
 * Author        : epnido
 * Creation date : Aug 25; 2023
 * Description   : Parameters File
 *------------------------------------------------------------------------------*/

`ifndef DESIGN_VARIABLES
`define DESIGN_VARIABLES

package design_variables;

	// General Design Variables
	localparam SEQ_LENGTH         	  =    32;
	localparam SEQ_LENGTH_W           =    $clog2(SEQ_LENGTH);
  
	localparam NUM_PU 	          	  =    16;
	   
	localparam NUM_PE_IN_PU		  	  =     4;	// -----------------------------
												// | PE 0=(00)b  |  PE 1=(01)b |
												// |------------ |-------------|
												// | PE 2=(10)b  |  PE 3=(11)b |
												// -----------------------------
	localparam NUM_PE_IN_PU_W		  =     $clog2(NUM_PE_IN_PU);
	localparam NUM_ROWS_PE			  = 	2; 
	localparam NUM_COLS_PE			  = 	2;
  
	localparam NUM_DIAGONALS 	  	  =    31; // number of diagonals
	localparam NUM_DIAGONALS_W 	  	  =    $clog2(NUM_DIAGONALS);
  
	localparam NUM_PU_MAIN_DIAGONAL   =    16; // number of PUs in main diagonal
	localparam NUM_PU_MAIN_DIAGONAL_W =    $clog2(NUM_PU_MAIN_DIAGONAL);
	
	localparam DATA_PACKET_SIZE   	=     3; // paket includes : 2 bits for direction and 1 bit for zero check
	
	localparam LETTER_WIDTH       	=     2; // 2 bits represent a letter one of : A,T,C,G

	localparam NUM_BUFF_REGS      	= 	  8; // number of registers for query/database sequences

	localparam SCORE_WIDTH          =     7; // represented by the maximum value of score

	localparam NUM_LETTERS_TO_CHOOSE =    2; // number of letters that are inserted to each pu
											 // from one of the sequences

	localparam SOURCE_WIDTH          =    2; // there are 3 directions where diagonal is default : 
												// '00' - diagonal
												// '01' - left
												// '10' - diagonal
												// '11' - top

	//max
	localparam SCORE_WIDTH_MAX = 7; // was 8
	
	
	//max of n , Max Registers
	//score width was 8 
	localparam  N 				 =	  4;
	localparam  M				 =    16;
	localparam  ROW_BITS_WIDTH	 =	  SEQ_LENGTH_W;
	localparam  COL_BITS_WIDTH	 =	  SEQ_LENGTH_W;
	

	// Max Registers
	localparam  COMPARE_UNITS	 =  16;

	
	// Processing Element
	localparam  GAP_PENALTY  = 	7'd2;
	localparam  MATCH        = 	7'd1;
	localparam  MISMATCH 	 = 	7'd1;
	
	// Processing Unit
	
	// Sequence Buffer
	localparam INPUT_WIDTH  = 8;
	localparam BUFF_CNT_W	= $clog2(NUM_BUFF_REGS);
	localparam BITS_REG     = 8;
	

	// Traceback
	localparam TOP				= 2'b11;
	localparam LEFT				= 2'b01;
	localparam LINE				= 3'b100;
	localparam START_END_SIGNAL	= 3'b111;
	

  endpackage // design variables package

`endif
