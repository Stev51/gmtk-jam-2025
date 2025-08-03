extends Node2D

func _on_start_button_pressed():
	Global.resume_game.emit()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
