###################################
#            Floorplan
###################################

puts -nonewline "\033\[1;32m"; #GREEN
puts "############### sourcing floorplan.tcl ###############"
puts -nonewline "\033\[0m"; #Reset

# set process node
setDesignMode -process 65

# set congestion effort
setDesignMode -congEffort high

# define chip sizes based on requirements
floorPlan -site core -d 1090.0 830.0 52 52 52 52

# define the tool which pads are VDD and VSS
source /users/iit/NF_scripts/innovus/scripts/glnets.src

# add io pads filling - fill the gaps between the pads
source /users/iit/NF_scripts/innovus/scripts/iofill.src

# define and generate the power grid
source ../scripts/powergrid.src
