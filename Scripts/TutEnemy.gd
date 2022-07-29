extends KinematicBody2D
signal killed()

func attacked():
	$AudioStreamPlayer2D.stop()
	self.connect("killed", get_node("/root/World/Door"), "_on_Enemy_killed")
	emit_signal("killed")
	$deathtimer.start()
	$AnimatedSprite.play("shotdown")


func _on_deathtimer_timeout():
	queue_free()
