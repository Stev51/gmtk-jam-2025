extends Control

func _ready():
	$CenterContainer4/ScoreText.text = "You output [b]" + Global.score + "[/b] boxes!"

func _on_start_button_pressed():
	
	$button.play()
	await get_tree().create_timer(0.2).timeout
	
	Global.resume_game.emit()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_title_button_pressed():
	
	$button.play()
	await get_tree().create_timer(0.2).timeout
	
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_start_button_mouse_entered():
	$hover.play()

func _on_title_button_mouse_entered():
	$hover.play()
