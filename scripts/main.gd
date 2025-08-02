extends Node2D

@onready var gui_node = $Player/GUI
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
	place_marker.pos_dist_x = float(place_marker.position.x) - float(player_node.position.x)
	place_marker.pos_dist_y = float(place_marker.position.y) - float(player_node.position.y)
	cell_pos -= world_node.TILE_OFFSET

func _input(event):

	if event is InputEventKey and event.is_pressed(): #Key presses

		if event.keycode == KEY_E: #E key pressed (mech place/destroy)
			
			if place_marker.check_distance_validity() and place_marker.out_of_bounds == false:

				var hovers = place_marker.get_hovered_mechanisms()
				if len(hovers) > 0: #If hovering over a mechanism, delete it and give the player the item

					if gui_node.is_player_inv_free(): #If there's no room, don't do anything
						collect_top_mechanism()
						delete_top_mechanism()

				else: #If not hovering, and inv item selected, place it

					if place_marker.cursor_state == Global.CursorStates.SELECTED and place_marker.placer_state == Global.PlacerStates.VALID:
						place_new_mechanism()
		
		elif event.keycode == KEY_Q: #Q key pressed (rotation)
			
			if place_marker.check_distance_validity() and place_marker.out_of_bounds == false:
				if len(place_marker.get_hovered_mechanisms()) > 0:
					rotate_top_mechanism()

	elif event is InputEventMouseButton and event.is_pressed(): #Mouse clicks
		var hovered = world_node.get_mech_from_node(place_marker.get_top_mechanism())
		if hovered == null:
			return null
		if event.button_index == MOUSE_BUTTON_LEFT: #Left click
			match place_marker.movable_state:
				Global.MovableStates.CANPUSHNORTH:
					hovered.playerPush(Util.Direction.UP) #PLACEHOLDER, push selected mech one tile up
				Global.MovableStates.CANPUSHEAST:
					hovered.playerPush(Util.Direction.RIGHT) #PLACEHOLDER, push selected mech one tile right
				Global.MovableStates.CANPUSHSOUTH:
					hovered.playerPush(Util.Direction.DOWN) #PLACEHOLDER, push selected mech one tile down
				Global.MovableStates.CANPUSHWEST:
					hovered.playerPush(Util.Direction.LEFT) #PLACEHOLDER. push selected mech one tile left

		if event.button_index == MOUSE_BUTTON_RIGHT: #Right click
			match place_marker.movable_state:
				Global.MovableStates.CANPULLNORTH:
					hovered.playerPush(Util.Direction.DOWN) #PLACEHOLDER, push selected mech one tile down
				Global.MovableStates.CANPULLEAST:
					hovered.playerPush(Util.Direction.LEFT) #PLACEHOLDER, push selected mech one tile left
				Global.MovableStates.CANPULLSOUTH:
					hovered.playerPush(Util.Direction.UP) #PLACEHOLDER, push selected mech one tile up
				Global.MovableStates.CANPULLWEST:
					hovered.playerPush(Util.Direction.RIGHT) #PLACEHOLDER, push selected mech one tile right

func place_new_mechanism():
	
	var selected_item = gui_node.get_selected_item()
	if selected_item != null:
		
		var mek_type = selected_item.placed_mech
		var created_mek = mek_type.new(world_node, cell_pos.x, cell_pos.y)
		world_node.addMechanism(created_mek)
		
		gui_node.remove_selected_item()
	
	#world_node.addMechanism(Box.new(world_node, cell_pos.x, cell_pos.y))

func delete_top_mechanism():
	var mek_obj = world_node.get_mech_from_node(place_marker.get_top_mechanism())
	world_node.deleteMechanism(mek_obj)

func collect_top_mechanism():
	var mek_obj = world_node.get_mech_from_node(place_marker.get_top_mechanism())
	if mek_obj != null:
		gui_node.add_to_player_inv(mek_obj.item)

func rotate_top_mechanism():
	var mek_obj = world_node.get_mech_from_node(place_marker.get_top_mechanism())
	mek_obj.rotate_dir()
