extends Node2D

@export var max_placement_distance_tiles = 2.5
var MAXIMUM_PLACEMENT_DISTANCE = max_placement_distance_tiles * 64

const TRANSPARENCY = 0.5
const GREEN = Color(0, 1, 0, TRANSPARENCY)
const YELLOW = Color(1, 1, 0, TRANSPARENCY)
const RED = Color(1, 0, 0, TRANSPARENCY)
const TRANSPARENT = Color(0, 0, 0, 0)

const SIZE = Vector2.ONE * 64

@onready var display_shape = $Polygon2D
@onready var collision_area = $Area2D

var state = Global.PlacerStates.VALID
var overlapping_player = false
var overlapping_mechanism = false
var out_of_bounds = false
var pos_dist = 0

func _process(delta):
	check_mechanism_overlaps()
	check_validity()
	display_shape.color = state_to_color()

func check_mechanism_overlaps():
	overlapping_mechanism = false
	if len(get_hovered_mechanisms()) > 0:
		overlapping_mechanism = true

func get_hovered_mechanisms():
	var ret = []
	for area in collision_area.get_overlapping_areas():
		if area.is_in_group("mechanism_selectors"):
			ret.append(area.get_parent())
	return ret

func check_validity():
	if out_of_bounds == true:
		state = Global.PlacerStates.OUT_OF_BOUNDS
	elif overlapping_mechanism == true:
		state = Global.PlacerStates.HARD_INVALID
	elif overlapping_player == true:
		state = Global.PlacerStates.SOFT_INVALID
	elif not check_distance_validity():
		state = Global.PlacerStates.SOFT_INVALID
	elif overlapping_player == true:
		state = Global.PlacerStates.SOFT_INVALID
	else:
		state = Global.PlacerStates.VALID

func state_to_color():
	match state:
		Global.PlacerStates.VALID:
			return GREEN
		Global.PlacerStates.SOFT_INVALID:
			return YELLOW
		Global.PlacerStates.HARD_INVALID:
			return RED
		Global.PlacerStates.OUT_OF_BOUNDS:
			return TRANSPARENT
		_:
			return TRANSPARENT

func check_distance_validity():
	return pos_dist <= MAXIMUM_PLACEMENT_DISTANCE

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		overlapping_player = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		overlapping_player = false

func _on_area_2d_area_entered(area):
	if area.is_in_group("valid_map_area"):
		out_of_bounds = false

func _on_area_2d_area_exited(area):
	if area.is_in_group("valid_map_area"):
		out_of_bounds = true
