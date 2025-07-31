extends CharacterBody2D

const SPEED = 400

func _physics_process(delta):
	player_movement()

func player_movement():
	
	var vec = Vector2.ZERO
	vec.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	vec.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = vec.normalized() * SPEED
	move_and_slide()
