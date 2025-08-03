extends Node2D

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	Global.resume_game.emit()

func _on_quit_button_pressed():
	get_tree().quit()
