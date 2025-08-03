extends Control

func _on_button_pressed():
	$button.play()
	hide()

func _on_button_mouse_entered():
	$hover.play()
