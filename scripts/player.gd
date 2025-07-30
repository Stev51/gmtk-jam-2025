extends CharacterBody2D

const SPEED = 500

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	
	var vec = Vector2.ZERO
	vec.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	vec.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = vec.normalized() * SPEED
	move_and_slide()
