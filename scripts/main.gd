extends Node2D

@onready var world_node = $World
@onready var main_tile_map_layer = $World/MainTileMapLayer
@onready var player_node = $Player
@onready var place_marker = $PlaceMarker

func _process(delta):
	
	var mouse_pos = main_tile_map_layer.get_local_mouse_position()
	var cell_pos = main_tile_map_layer.local_to_map(mouse_pos)
	place_marker.position = main_tile_map_layer.map_to_local(cell_pos) + world_node.position
	
	place_marker.pos_dist = place_marker.position.distance_to(player_node.position)
