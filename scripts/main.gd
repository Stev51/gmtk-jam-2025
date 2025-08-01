extends Node2D

@onready var world_node = $World
@onready var main_tile_map_layer = $World/MainTileMapLayer
@onready var mechanisms_parent_node = $World/Mechanisms
@onready var player_node = $Player
@onready var place_marker = $PlaceMarker

var mouse_pos = Vector2.ZERO
var cell_pos = Vector2.ZERO

func _process(delta):
	
	mouse_pos = main_tile_map_layer.get_local_mouse_position()
	cell_pos = main_tile_map_layer.local_to_map(mouse_pos)
	place_marker.position = main_tile_map_layer.map_to_local(cell_pos) + world_node.position
	
	place_marker.pos_dist = place_marker.position.distance_to(player_node.position)

func _input(event):
	
	if event is InputEventKey and event.is_pressed(): #Key presses
		
		if event.keycode == KEY_E: #E key pressed
			if place_marker.check_distance_validity():
				
				var hovers = place_marker.get_hovered_mechanisms()
				if len(hovers) > 0: #If hovering over a mechanism, delete it
					
					for mek in hovers:
						mek.queue_free()
					
				else: #If not hovering, and inv item selected, place it
					
					if place_marker.cursor_state == Global.CursorStates.SELECTED and place_marker.placer_state == Global.PlacerStates.VALID:
						place_new_mechanism()
	
	elif event is InputEventMouseButton and event.is_pressed(): #Mouse clicks
		
		if event.button_index == MOUSE_BUTTON_LEFT: #Left click
			pass #PLACEHOLDER
		
		if event.button_index == MOUSE_BUTTON_RIGHT: #Right click
			pass #PLACEHOLDER

func place_new_mechanism():
	
	world_node.addMechanism(Box.new(world_node, cell_pos.x, cell_pos.y), world_node.FOREGROUND) #For now it is box
	world_node.drawMap()
