extends Panel

func _on_Play_pressed():
	SceneChanger.change_scene("res://Scenes/Level_0.tscn")

func _on_Exit_pressed():
	get_tree().quit()
