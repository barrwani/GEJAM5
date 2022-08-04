extends Node2D

export var pressed = false


func _on_Button_buttonpressed():
	if ! pressed:
		pressed = true
		$AnimationPlayer.play("elevate")
	else:
		$AnimationPlayer.play_backwards("elevate")
		pressed = false
