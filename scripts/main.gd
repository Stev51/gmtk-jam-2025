extends Node2D

@onready var place_marker = $PlaceMarker
@onready var world_node = $World
@onready var main_tile_map_layer = $World/MainTileMapLayer

func _process(delta):
	
	var mouse_pos = main_tile_map_layer.get_local_mouse_position()
	var cell_pos = main_tile_map_layer.local_to_map(mouse_pos)
	place_marker.position = main_tile_map_layer.map_to_local(cell_pos) + world_node.position
