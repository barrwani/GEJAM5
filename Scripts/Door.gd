extends Area2D

export var next_scene = "res://Scenes/Level_0.tscn"
export var total_enemies = 1
var killed_enemies = 0
var just_turned = false



func _process(delta):
	if killed_enemies == total_enemies:
		if !just_turned:
			$AnimationPlayer.play("doorunlocked")
			#$SFX.play()
			just_turned = true

func _on_Door_body_entered(body):
	if body.is_in_group("player") && body.connected && killed_enemies == total_enemies:
		pass

func _on_Enemy_killed():
	killed_enemies +=1