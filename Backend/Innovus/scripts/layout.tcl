puts "############### sourcing layout.tcl ###############"

#Floorplan:
set init_design_uniquify 1
source ../scripts/floorplan.tcl

#Placement: 
source ../scripts/placement.tcl 
source ../scripts/tie.tcl 
optDesign -preCTS 
saveDesign preCTS.enc 

#CTS: 
source ../scripts/cts.tcl 
optDesign -postCTS 
saveDesign postCTS_final.enc 

#Route: 
source ../scripts/route_block.tcl 
source ../scripts/route.tcl 
optDesign -hold -postRoute 
optDesign -setup -postRoute

saveDesign postRoute.enc 

#ECO: 
set filename "../report/postRoute.rpt" 
redirect $filename { timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix top_postRoute -outDir ../report/ } redirect -append $filename { timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix top_postRoute -outDir ../report/ } source ../scripts/power_analysis.tcl saveDesign postPower.enc 
#Save netlist with these flags. Needed for Prime Time: 
saveNetlist ../dataout/eco/top_post_layout.v -topModuleFirst -flat -removePowerGround 
source ../scripts/xt.tcl























ts "############### sourcing layout.tcl ###############"
#Floorplan:
set init_design_uniquify 1
source ../scripts/floorplan.tcl
#source ../scripts/route_block.tcl

#Placement:
source ../scripts/placement.tcl
source ../scripts/tie.tcl
optDesign -preCTS
saveDesign preCTS.enc
#CTS:
source ../scripts/cts.tcl
optDesign -postCTS
saveDesign postCTS_final.enc
#Route:
source ../scripts/route_block.tcl
source ../scripts/route.tcl
optDesign -hold -postRoute
optDesign -setup -postRoute
saveDesign postRoute.enc
#ECO:
set filename "../report/postRoute.rpt"
redirect $filename { timeDesign -postRoute -hold -pathReports -
slackReports -numPaths 50 -prefix top_postRoute -outDir ../report/ }
redirect -append $filename { timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix top_postRoute -outDir ../report/ }
source ../scripts/power_analysis.tcl
#Save netlist with these flags. Needed for Prime Time:
saveNetlist ../dataout/eco/top_post_layout.v -topModuleFirst -flat -removePowerGround
source ../scripts/xt.tcl
