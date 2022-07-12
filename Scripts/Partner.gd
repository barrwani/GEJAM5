extends KinematicBody2D

var thrown = false
var attached = true
var movespeed = 400
var velocity = Vector2()
var jumping = false
var flipped = false
var gravity = 1600
var jumpspeed = -500
var leverpull = false
var firing = false
var move_input
onready var animatedsprite = $StateMachine/AnimatedSprite

func _ready():
	$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _apply_gravity(delta):
	if !attached:
		velocity.y += delta * gravity
	else:
		velocity.y = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") && !thrown:
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		reparent(self, body)
		if body.animatedsprite.flip_h:
			position.x = 18
		else:
			position.x = -18
		position.y = -4
		attached = true

func _apply_movement():
	var was_on_floor = is_on_floor()
	if is_on_floor() && !attached:
		$Area2D/CollisionShape2D.set_deferred("disabled", false)
		thrown = false
		velocity.x = 0
	velocity = move_and_slide(velocity, Vector2(0,-1))
	if is_on_floor() and jumping:
		jumping = false


func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.call_deferred("remove_child", child)
	new_parent.call_deferred("add_child", child)

func _on_Player_throw(throwspeed):
	var glob = global_position
	reparent(self, get_node('/root/World'))
	position = glob
	thrown = true
	attached = false
	if animatedsprite.flip_h:
		velocity.x = -throwspeed
	else:
		velocity.x = throwspeed
	velocity.y = -400 -(throwspeed/2)


func _on_Player_fliph(flipped):
	if flipped:
		animatedsprite.flip_h = true
		position.x = 18
	else:
		position.x = -18
		animatedsprite.flip_h = false
