extends KinematicBody2D
signal throw(throwspeed)
signal fliph(flipped)
signal moving()
signal stopped()

var gravity = 3100
var connected = true
var jumping = false
var pickingup = false
var movespeed = 600
var jumpspeed = -1350
var velocity = Vector2()
var dead = false
var charge = false
var linebreak = false
var move_input
var was_on_floor

var holding = false
var waspicked
var throwspeed = 300
var justpicked = false
var throwing = false
onready var line = $Line2D
var max_points = 9


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
	line.activate()
	var pos = $Position2D.position
	var vel = Vector2(throwspeed/ 10, -50- throwspeed/10)
	if animatedsprite.flip_h:
		vel.x *= -1
	for i in max_points:
		line.add_point(pos)
		vel.y += (31) 
		pos += vel
		if linebreak:
			linebreak = false
			break
	$Range.set_deferred("visible", true)
	$Range.position.x = pos.x
	$Range.position.y = pos.y -100


func throw():
	$Range.set_deferred("visible", false)
	throwing = true
	$throwtimer.start()
	emit_signal("throw", throwspeed)

func _apply_movement():
	was_on_floor = is_on_floor()
	if !connected:
		waspicked = true
	if connected:
		if waspicked:
			justpicked = true
			waspicked = false
		else:
			justpicked = false
		movespeed = 600
	else:
		movespeed = 900
	if !pickingup:
		velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_floor() and jumping:
		jumping = false

func _handle_move_input():
	if !dead:
		if !was_on_floor && is_on_floor():
			$StateMachine/Land.play()
		move_input = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
		if move_input != 0:
			emit_signal("moving")
			animatedsprite.flip_h = move_input != 1
			if animatedsprite.flip_h && connected:
				$Position2D.position.x = 11
				emit_signal("fliph", true)
			elif !animatedsprite.flip_h && connected:
				$Position2D.position.x = -11
				emit_signal("fliph", false)
			velocity.x = lerp(velocity.x, movespeed * move_input,0.1)
		else:
			emit_signal("stopped")
			velocity.x = 0
				
	


func death():
	dead = true
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


func _on_Area2D_body_entered(body):
	if body.is_in_group("platform") || body.is_in_group("floor"):
		linebreak = true



