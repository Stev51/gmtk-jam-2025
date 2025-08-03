extends Control

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		if Global.game_state == Global.GameStates.RUNNING:
			Global.pause_game.emit()
		elif Global.game_state == Global.GameStates.PAUSED:
			Global.resume_game.emit()

func _on_resume_button_pressed():
	Global.resume_game.emit()

func _on_title_button_pressed():
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")
