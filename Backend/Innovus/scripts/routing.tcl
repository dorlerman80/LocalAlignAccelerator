###################################
#            Routing
###################################

setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin corePin floatingStripe } -layerChangeRange { M1(1) AP(10) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { M1(1) AP(10) } -nets { VSS VDD } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { M1(1) AP(10) }