extends CharacterBody2D

@export var SPEED = 400

@onready var anim: Sprite2D = $Sprite2D

func _physics_process(delta):
	player_movement()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			anim.flip_h = true
		elif event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			anim.flip_h = false

func player_movement():

	var vec = Vector2.ZERO
	vec.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	vec.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	velocity = vec.normalized() * SPEED
	move_and_slide()
