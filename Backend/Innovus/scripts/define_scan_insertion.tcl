###################################
# define scan insertion
###################################

specifyScanChain scan_in1 -start "I26/I1/C" -stop "I39/I1/I"
specifyScanChain scan_in2 -start "I27/I1/C" -stop "I40/I1/I"
setScanReorderMode -compLogic true
scantrace