extends Node2D

const MAXIMUM_PLACEMENT_DISTANCE = 64 * 2.5

const TRANSPARENCY = 0.5
const GREEN = Color(0, 1, 0, TRANSPARENCY)
const YELLOW = Color(1, 1, 0, TRANSPARENCY)
const RED = Color(1, 0, 0, TRANSPARENCY)
const TRANSPARENT = Color(0, 0, 0, 0)

const SIZE = Vector2.ONE * 64

@onready var display_shape = $Polygon2D
@onready var collision_area = $Area2D

enum States {VALID, SOFT_INVALID, HARD_INVALID, OUT_OF_BOUNDS}

var state = States.VALID
var overlapping_player = false
var overlapping_mechanism = false
var out_of_bounds = false
var pos_dist = 0

func _process(delta):
	check_mechanism_overlaps()
	check_validity()
	display_shape.color = state_to_color(state)

func check_mechanism_overlaps():
	overlapping_mechanism = false
	for area in collision_area.get_overlapping_areas():
		if area.is_in_group("mechanisms"):
			overlapping_mechanism = true

func check_validity():
	if out_of_bounds == true:
		state = States.OUT_OF_BOUNDS
	elif overlapping_mechanism == true:
		state = States.HARD_INVALID
	elif overlapping_player == true or pos_dist > MAXIMUM_PLACEMENT_DISTANCE:
		state = States.SOFT_INVALID
	else:
		state = States.VALID

func state_to_color(state):
	match state:
		States.VALID:
			return GREEN
		States.SOFT_INVALID:
			return YELLOW
		States.HARD_INVALID:
			return RED
		States.OUT_OF_BOUNDS:
			return TRANSPARENT
		_:
			return TRANSPARENT

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
