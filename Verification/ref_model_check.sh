#!/bin/bash

vcs -kdb -sverilog -debug_access+all -full64 ../Design/RTL/design_variables.vh ref_model.sv

./simv