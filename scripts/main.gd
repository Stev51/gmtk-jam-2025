extends Node2D

@onready var world_node = $World
@onready var main_tile_map_layer = $World/MainTileMapLayer
@onready var mechanisms_parent_node = $World/Mechanisms
@onready var player_node = $Player
@onready var place_marker = $PlaceMarker

# TEMP #
var mechanism_scene = preload("res://scenes/mechanism.tscn")

func _process(delta):
	
	var mouse_pos = main_tile_map_layer.get_local_mouse_position()
	var cell_pos = main_tile_map_layer.local_to_map(mouse_pos)
	place_marker.position = main_tile_map_layer.map_to_local(cell_pos) + world_node.position
	
	place_marker.pos_dist = place_marker.position.distance_to(player_node.position)

func _input(event):
	
	if event is InputEventMouseButton and event.is_pressed(): #Mouse clicks
		
		if event.button_index == MOUSE_BUTTON_LEFT: #Left click, place new mechanism
			if place_marker.state == Global.States.VALID:
				place_new_mechanism()
		
		if event.button_index == MOUSE_BUTTON_RIGHT: #Right click, delete hovered mechanism
			for mek in place_marker.get_hovered_mechanisms():
				mek.queue_free()

func place_new_mechanism():
	
	var new_mek = mechanism_scene.instantiate()
	
	mechanisms_parent_node.add_child(new_mek)
	new_mek.position = place_marker.position - world_node.position
