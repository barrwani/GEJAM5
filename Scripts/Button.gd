extends Area2D


var pressed = false
signal unpress()
signal buttonpressed()

func _ready():
	pass


func press():
	if !pressed:
		emit_signal("unpress")
		$AudioStreamPlayer.play()
		pressed = true
		$ButtonActivated.set_deferred("visible", true)
		$ButtonColor.set_deferred("visible", false)
		emit_signal("buttonpressed")

func unpress():
	if pressed:
		pressed = false
		$ButtonActivated.set_deferred("visible", false)
		$ButtonColor.set_deferred("visible", true)
