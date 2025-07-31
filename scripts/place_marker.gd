extends Node2D

const TRANSPARENCY = 0.5
const GREEN = Color(0, 1, 0, TRANSPARENCY)
const YELLOW = Color(1, 1, 0, TRANSPARENCY)
const RED = Color(1, 0, 0, TRANSPARENCY)

const SIZE = Vector2.ONE * 64
@onready var display_shape = $Polygon2D

enum States {VALID, SOFT_INVALID, HARD_INVALID}

var state = States.VALID
var overlapping_player = false

func _process(delta):
	check_validity()
	display_shape.color = state_to_color(state)

func check_validity():

	if overlapping_player == true:
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
		_:
			return RED

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		overlapping_player = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		overlapping_player = false
