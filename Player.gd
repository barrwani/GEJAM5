extends KinematicBody2D
signal throw(throwspeed)
signal fliph(flipped)

var gravity = 1600
var connected = true
var jumping = false
var pickingup = false
var movespeed = 400
var jumpspeed = -500
var velocity = Vector2()
var dead = false
var charge = false
var move_input
var holding = false
var throwspeed = 200
var throwing = false
onready var line = $Line2D
var max_points = 50


onready var animatedsprite = $StateMachine/AnimatedSprite

func _ready():
	line.hide()

func _apply_gravity(delta):
	velocity.y += delta * gravity

func _process(delta):
	if holding:
		update_trajectory(delta)

func jump():
	velocity.y = jumpspeed

func update_trajectory(delta):
	line.clear_points()
	var pos = $Position2D.position
	pos.y -= 4
	var vel = throwspeed * $Position2D.global_transform.x
	if animatedsprite.flip_h:
		vel *= -1

	vel.y = -400 -(throwspeed/2)
	for i in max_points:
		line.add_point(pos)
		vel.y += (gravity * delta) 
		pos += vel * delta
		#if pos.y > $Ground.position.y - 25:
		#	break

func throw():
	throwing = true
	$throwtimer.start()
	emit_signal("throw", throwspeed)

func _apply_movement():
	var was_on_floor = is_on_floor()
	if connected:
		movespeed = 400
	else:
		movespeed = 500
	if !pickingup:
		velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_floor() and jumping:
		jumping = false

func _handle_move_input():
	if !dead:
		move_input = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
		if move_input != 0:
			animatedsprite.flip_h = move_input != 1
			if animatedsprite.flip_h && connected:
				$Position2D.position.x = 17
				emit_signal("fliph", true)
			elif !animatedsprite.flip_h && connected:
				$Position2D.position.x = -17
				emit_signal("fliph", false)
			velocity.x = lerp(velocity.x, movespeed * move_input,0.1)
		else:
			velocity.x = 0


func death():
	get_tree().reload_current_scene()


func _on_Partner_body_entered(body):
	if body.is_in_group("player") && ! throwing:
		pickingup = true
		$pickuptimer.start()
		connected = true


func _on_throwtimer_timeout():
	throwing = false


func _on_pickuptimer_timeout():
	pickingup = false
