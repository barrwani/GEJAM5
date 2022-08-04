extends Node2D

export var pressed = false


func _on_Button_buttonpressed():
	if ! pressed:
		$AnimationPlayer.play("moveup")
		pressed = true
	else:
		$AnimationPlayer.play_backwards("moveup")
		pressed = false
