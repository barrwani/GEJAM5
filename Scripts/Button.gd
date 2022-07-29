extends Area2D

signal buttonpressed()

func _ready():
	pass


func press():
	$AudioStreamPlayer.play()
	$ButtonActivated.set_deferred("visible", true)
	$ButtonColor.set_deferred("visible", false)
	emit_signal("buttonpressed")
