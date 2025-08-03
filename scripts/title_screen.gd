extends Node2D

func _on_start_button_pressed():
	$CenterContainer/button.play()
	await get_tree().create_timer(0.2).timeout
	Global.resume_game.emit()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed():
	$"CenterContainer2/door click".play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_start_button_mouse_entered() -> void:
	$hover.play()

func _on_quit_button_mouse_entered() -> void:
	$hover.play()
