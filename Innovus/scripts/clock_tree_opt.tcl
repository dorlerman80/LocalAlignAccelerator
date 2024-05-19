create_ccopt_clock_tree -name top -source I5/I1/C
set_ccopt_mode -cts_inverter_cells "INVD0LVT INVD1LVT INVD2LVT INVD3LVT INVD4LVT INVD6LVT INVD8LVT INVD12LVT INVD16LVT INVD20LVT INVD24LVT" -cts_target_skew  0.2 -cts_target_slew  0.2
set_ccopt_mode -cts_buffer_cells {BUFFD0LVT BUFFD1LVT BUFFD2LVT BUFFD3LVT BUFFD4LVT BUFFD6LVT BUFFD8LVT BUFFD12LVT BUFFD16LVT BUFFD20LVT BUFFD24LVT}
#set_ccopt_mode -route_top_top_preferred_layer M4 -route_top_bottom_preferred_layer M3
set_ccopt_property target_max_trans 250ps
set_ccopt_property  target_skew 0.3
create_route_type -name RT_trunk_leaf -top_preferred_layer M4 -bottom_preferred_layer M3 -preferred_routing_layer_effort high
set_ccopt_property route_type RT_trunk_leaf  -net_type leaf
set_ccopt_property route_type RT_trunk_leaf  -net_type trunk
set_ccopt_mode -integration native
ccopt_design -cts

