extends Node2D

# Consider moving anything to custom resources
# Walls and UI will be non-mechanisms, a different Node2D and Control respectively

#Properties needed: walkable; movable (pickup-able/shovable) (i.e. false for in/out conveyors); 

#Methods needed: detect player hands collision -> link incoming signals; push/pull signal -> move;
#detect box collision -> link outgoing signals; clock signal -> perform operation on linked object;
#hands uncollide -> unlink; box uncollide -> unlink
