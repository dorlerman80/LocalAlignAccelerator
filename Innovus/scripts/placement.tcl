###################################
#            Placement
###################################

puts -nonewline "\033\[1;34m"; #BLUE
puts "############### sourcing placement.tcl ###############"
puts -nonewline "\033\[0m"; #Reset


#TODO: tell it to be 0.35 in צפיפות

# configure placer:
# enable routing congestion driven placement -congEffort high
# enable timing driven placement -timingDriven 1
# enable routing congestion optimization -doCongOpt 1
# unblock std cells pins -checkPinLayerForAccess { 1 }
setPlaceMode -reset
setPlaceMode -congEffort high -timingDriven 1 -clkGateAware 1 -powerDriven 0 -ignoreScan 1 -reorderScan 1 -ignoreSpare 0 -placeIOPins 0 -moduleAwareSpare 0 -maxDensity 0.5 -preserveRouting 1 -rmAffectedRouting 0 -checkRoute 0 -swapEEQ 0
setPlaceMode -fp false
place_design

# enable multi CPU work
setMultiCpuUsage -localCpu 4 -keepLicense true

# run placement with pre and post placement timing optimization
placeDesign -inPlaceOpt -prePlaceOpt

