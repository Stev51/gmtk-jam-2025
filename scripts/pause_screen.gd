extends Control

@onready var main_screen = $MainScreen
@onready var tut_screen = $TutorialScreen

enum DisplayState {MAIN, TUTORIAL}
var display_state = DisplayState.MAIN

func _ready():
	Global.pause_game.connect(pause)

func _input(event):
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		if Global.game_state == Global.GameStates.RUNNING:
			Global.pause_game.emit()
		elif Global.game_state == Global.GameStates.PAUSED:
			Global.resume_game.emit()

func pause():
	if display_state == DisplayState.TUTORIAL:
		toggle_display()

func toggle_display():
	if display_state == DisplayState.MAIN:
		display_state = DisplayState.TUTORIAL
		main_screen.hide()
		tut_screen.show()
	else:
		display_state = DisplayState.MAIN
		main_screen.show()
		tut_screen.hide()

func _on_resume_button_pressed():
	$button.play()
	Global.resume_game.emit()

func _on_title_button_pressed():
	$button.play()
	await get_tree().create_timer(0.2).timeout
	Global.resume_game.emit()
	Global.game_state = Global.GameStates.TITLE
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_tutorial_button_pressed():
	$button.play()
	toggle_display()

func _on_resume_button_mouse_entered() -> void:
	$hover.play()

func _on_title_button_mouse_entered() -> void:
	$hover.play()

func _on_tutorial_button_mouse_entered():
	$hover.play()
