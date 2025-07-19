`ifndef VERIF_UTILS
`define VERIF_UTILS
package verif_utils;

   // clk configuration
   typedef enum{
	  CLK_CFG_DEFAULT = 0,
	  DIFF_PERIOD = 1,
	  DIFF_DUTY_CYCLE = 2,
	  DIFF_BOTH = 3,
	  DIFF_BOTH_CLK_RND = 4,
	  RND_GATED_CLK = 5
   } clk_cfg_enum;
   
   // rst configuration
   typedef enum{
	  RST_CFG_DEFAULT = 0,
	  DIFF_DURATION = 1
   } rst_cfg_enum;

   // start configuration
   typedef enum{
	  START_CFG_DEFAULT = 0,
	  DIFF_DURATION_START = 1
   } start_cfg_enum;

   typedef struct {
	  logic [design_variables::NUM_INSERT_CYCLES-1:0][design_variables::INPUT_WIDTH-1:0] data;
	  int typ;  // 0 for "query", 1 for "database"
   } seq_t;
   
   typedef struct {
	   bit [2:0] out_letters[$];
   } out_seq_t;
   
   
   
   localparam END_OUTPUT = 3'b111;
   localparam START_OUTPUT = 3'b111;
   
  

endpackage
`endif
