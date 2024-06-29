package verif_utils;

    // clk configuration
     
    typedef enum{
                  CFG_DEFAULT = 0,
                  DIFF_PERIOD = 1,
                  DIFF_DUTY_CYCLE = 2,
                  DIFF_BOTH = 3,
                  DIFF_BOTH_CLK_RND = 4
    } clk_cfg_enum;


    typedef enum{
                  CFG_DEFAULT = 0,
                  DIFF_DURATION = 1,
    } rst_cfg_enum;


endpackage
