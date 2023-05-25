extends Node2D

export var pressed = false
var moving = false




func _on_Button_buttonpressed():
	$AnimationPlayer.play("move")
	moving = true
	pressed = true


func _on_Button_unpress():
	$AnimationPlayer.play_backwards("move")
	moving = true
	pressed = false



func _on_AnimationPlayer_animation_finished(anim_name):
	moving = false


