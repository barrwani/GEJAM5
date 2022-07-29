extends StaticBody2D

export var pressed = false


func _on_Button_buttonpressed():
	if ! pressed:
		$CollisionShape2D.set_deferred("disabled", false)
		$Platform.set_deferred("visible", true)
		pressed = true
	else:
		$CollisionShape2D.set_deferred("disabled", true)
		$Platform.set_deferred("visible", false)
		pressed = false
