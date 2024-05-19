###################################
#       Extract Parasitics
###################################

puts -nonewline "\033\[1;34m"; #BLUE
puts "############### sourcing extract_parasitics.tcl ###############"
puts -nonewline "\033\[0m"; #Reset
puts ""

reset_parasitics
extractRC
rcOut -rc_corner SlowRC -spef ../dataout/eco/top_slow.SPEF
reset_parasitics
extractRC
rcOut -rc_corner FastRC -spef ../dataout/eco/top_fast.SPEF