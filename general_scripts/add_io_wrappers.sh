#!/bin/bash

########################################
# input parameters: .1 lab username
#                   .2 netlist.v file
#                   .3 top module name
#
# Operation :
# makes an IO pads file , adds the wrapper modules 
# and the hierarchy dependent from the wrappers.
########################################

# Correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <user name> <netlist.v file> <top_module_name>"
    exit 1
fi

# Parse arguments
user_name="$1"
netlist_file="$2"
top_module_name="$3"
echo "First argument: $user_name is defined as the user"
echo "Second argument: $netlist_file is defined as netlist.v"
echo "Third argument: $top_module_name is defined as the top module name"

# Copy the environment globals and mmc.view file to innovus
innovus_path="/users/epegag/TSMC65/innovus"
cp "$innovus_path/work/env.globals" .
cp "$innovus_path/datain/mmmc.view" ../datain

if [ $? -ne 0 ]; then
    echo "Error copying files. Exiting."
    exit 1
fi

echo "......................"
sleep 2
echo "Copied env.globals"
sleep 2
echo "Copied mmc.view" 

# Make the I.O file
datain_path="/users/$user_name/Project/innovus/datain"
cd "$datain_path"
/users/iit/cadence/tsl018c/gentop.pl "$netlist_file" "$top_module_name"

if [ $? -ne 0 ]; then
    echo "Error running gentop.pl. Exiting."
    exit 1
fi

echo "......................"
sleep 2
echo "Made the I.O file"

# Add pad wrappers (added content from pads.v file)
pads_file_path="/users/iit/cadence/tsmc65/pads.v"
cat "$pads_file_path" > temp_file.v
cat top.v >> temp_file.v
mv temp_file.v top.v
echo "......................"
sleep 3
echo "Made the I.O wrappers"

# Add I1 to all pads
sed -E -i 's/(Pad: [A-Za-z0-9_]+)([[:space:]]+[NSEW])/\1\/I1\2/g' "$datain_path/top.io"
echo "......................"
sleep 3
echo "Added pads hierarchy"
