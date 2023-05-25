extends KinematicBody2D

signal killed()


var dead = false
var movespeed = 100
var velocity = Vector2()
onready var animatedsprite = $AnimatedSprite


func _physics_process(delta):
	if ! dead:
		velocity = move_and_slide(velocity, Vector2(0,-1))
		if animatedsprite.flip_h:
			if ! $RayCast2D.is_colliding():
				$RayCast2D.position.x *= -1
				$AnimationPlayer.play_backwards("New Anim")
				animatedsprite.flip_h = false
			movespeed = -100
		else:
			if ! $RayCast2D.is_colliding():
				$AnimationPlayer.play("New Anim")
				$RayCast2D.position.x *= -1
				animatedsprite.flip_h = true
			movespeed = 100
		velocity.x = movespeed


func attacked():
	dead = true
	movespeed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$AudioStreamPlayer2D.stop()
	$Area2D.queue_free()
	self.connect("killed", get_node("/root/World/Door"), "_on_Enemy_killed")
	emit_signal("killed")
	$deathtimer.start()
	$AnimatedSprite.play("shotdown")

func _on_Proximity_body_entered(body):
	if ! body.is_in_group("player") && ! body.is_in_group("partner") && body != self:
		if animatedsprite.flip_h:
			$AnimationPlayer.play_backwards("New Anim")
			animatedsprite.flip_h = false
		else:
			$AnimationPlayer.play("New Anim")
			animatedsprite.flip_h = true
	elif body.is_in_group("player"):
		body.death()


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		body.death()


func _on_deathtimer_timeout():
	queue_free()
