extends Panel

func _on_Play_pressed():
	SceneChanger.change_scene("res://Scenes/Level_0.tscn")

func _on_Exit_pressed():
	get_tree().quit()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "auto":
		$MenuOST.play()

func _process(delta):
	if $Play.is_hovered() || $Settings.is_hovered() || $Exit.is_hovered():
		$Panel.visible = true
	else:
		$Panel.visible = false


func _ready():
	Ost.stop()
	Engine.set_target_fps(60)
