#!/bin/bash

vcs -kdb -sverilog -debug_access+all -full64 Project_Modules/RTL/controller.sv Project_Modules/RTL/flipflop.sv Project_Modules/RTL/matrix_calculation.sv Project_Modules/RTL/max.sv Project_Modules/RTL/max_registers.sv Project_Modules/RTL/processing_element.sv Project_Modules/RTL/sequence_buffer.sv Project_Modules/RTL/traceback.sv Project_Modules/RTL/design_variables.vh Project_Modules/RTL/inverter.sv Project_Modules/RTL/matrix_memory.sv Project_Modules/RTL/max_of_n.sv Project_Modules/RTL/processing_unit.sv Project_Modules/RTL/top.sv Project_Modules/tb/top_tb.sv


vcs -kdb -sverilog -debug_access+all -full64 controller.sv flipflop.sv matrix_calculation.sv max.sv max_registers.sv processing_element.sv sequence_buffer.sv traceback.sv design_variables.vh inverter.sv matrix_memory.sv max_of_n.sv processing_unit.sv top.sv top_tb.sv


