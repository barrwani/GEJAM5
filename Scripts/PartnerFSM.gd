extends "res://Scripts/StateMachine.gd"


func _ready():
	add_state("attached")
	add_state("independent")
	add_state("in_air")
	add_state("firing")
	call_deferred("set_state", states.attached)



func _state_logic(delta):
	parent._apply_movement()
	parent._apply_gravity(delta)
	if [states.attached].has(state):
		$AnimatedSprite.set_deferred("visible", false)
	else:
		$AnimatedSprite.set_deferred("visible", true)


func _get_transition(delta):
	match state:
		states.attached:
			if parent.thrown:
				return states.in_air
		states.firing:
			if !parent.firing:
				return states.independent
		states.in_air:
			if parent.is_on_floor():
				parent.thrown = false
				return states.independent
			elif parent.attached:
				return states.attached
		states.independent:
			if parent.attached:
				return states.attached
			elif parent.firing:
				return states.firing

			
func _enter_state(new_state, old_state):
	match new_state:
		states.independent:
			$Throw.stop()
			$AnimatedSprite.play("Land")
			$Label.text = "Independent"
		states.attached:
			$Label.text = "Attached"
		states.firing:
			$AnimatedSprite.play("Shoot")
			$Slingshot.play()
			$Label.text = "firing"
		states.in_air:
			$Throw.play()
			$AnimatedSprite.play("Launch")
			$Label.text = "thrown"
