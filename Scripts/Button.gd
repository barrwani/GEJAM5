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
	else:
		unpress()
		

func unpress():
	pressed = false
	$ButtonActivated.set_deferred("visible", false)
	$ButtonColor.set_deferred("visible", true)
	$AudioStreamPlayer.play()
	emit_signal("unpress")
