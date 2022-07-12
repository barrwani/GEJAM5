extends "res://Scripts/StateMachine.gd"

var add = false
var hold = false
func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("throw")
	add_state("pickup")
	add_state("dead")
	call_deferred("set_state",states.idle)


func _input(event):
	if [states.idle, states.run].has(state):
		if event.is_action_pressed("jump") && ! parent.jumping:
			parent.jump()
			parent.jumping = true
	if [states.idle, states.run, states.fall, states.jump].has(state):
		if event.is_action_pressed("throw") && parent.connected:
			$Timer.start()
			parent.holding = true
			hold = true
			parent.line.show()
		if event.is_action_released("throw") && parent.connected:
			parent.connected = false
			hold = false
			parent.line.hide()
			add = false
			parent.throw()
			parent.throwspeed = 200
			parent.holding = false


func _state_logic(delta):
	parent._apply_movement()
	parent._handle_move_input()
	parent._apply_gravity(delta)


func _get_transition(delta):
	match state:
		states.idle:
			if parent.dead:
				return states.dead
			elif parent.throwing:
				return states.throw
			elif ! parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y >= 0 && ! parent.is_on_floor():
					parent.jumping = false
					return states.fall
			elif abs(parent.velocity.x) > 50:
				parent.jumping = false
				return states.run
		states.run:
			if parent.dead:
				return states.dead
			elif parent.throwing:
				return states.throw
			elif !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					parent.jumping = false
					return states.fall
			elif abs(parent.velocity.x) == 0:
				parent.jumping = false
				return states.idle
		states.throw:
			if !parent.throwing:
				return states.idle
		states.jump:
			if parent.dead:
				return states.dead
			elif parent.velocity.y >= 0 and ! parent.is_on_floor():
				return states.fall
			elif parent.is_on_floor():
				parent.jumping = false
				return states.idle
		states.fall:
			if parent.dead:
				return states.dead
			elif parent.is_on_floor():
				parent.jumping = false
				return states.idle
		states.dead:
			if !parent.dead:
				return states.idle

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			$Label.text = "Idle"
			#$AnimatedSprite.play("Idle")
		states.run:
			$Label.text = "Run"
			#$AnimatedSprite.play("Run")
		states.jump:
			$Label.text = "Jump"
			#$AnimatedSprite.play("Jump")
		states.dead:
			$Label.text = "Dead"
		states.fall:
			$Label.text = "Fall"
			#$AnimatedSprite.play("Fall")
		states.throw:
			$Label.text = "Throw"


func _exit_state(old_state, new_state):
	pass

func _process(delta):
	if add && parent.throwspeed <400:
		parent.throwspeed += 10



func _on_Timer_timeout():
	if hold:
		add = true
