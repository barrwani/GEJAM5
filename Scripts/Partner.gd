extends KinematicBody2D

var thrown = false
var attached = true
var velocity = Vector2()
var jumping = false
var flipped = false
var parentmoving = false
var gravity = 2800
var firing = false
var was_on_floor
var move_input
onready var animatedsprite = $StateMachine/AnimatedSprite

func _ready():
	$CollisionShape2D2.set_deferred("disabled", true)
	$AbilityArea/Range.set_deferred("visible", false)
	$AbilityArea/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)


func _apply_gravity(delta):
	if !was_on_floor && is_on_floor():
		$StateMachine/Land.play()
	if !attached:
		velocity.y += delta * gravity
	else:
		velocity.y = 0

func _on_Area2D_body_entered(body):
	if body.is_in_group("player") && !thrown:
		$AbilityArea/Range.set_deferred("visible", false)
		attached = true
		$CollisionShape2D2.set_deferred("disabled", true)
		$AbilityArea/CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		reparent(self, body)
		if body.animatedsprite.flip_h:
			position.x = 10
		else:
			position.x = -10
		position.y = -67


func _apply_movement():
	was_on_floor = is_on_floor()
	if is_on_floor() && !attached:
		$AbilityArea/Range.set_deferred("visible", true)
		$AbilityArea/CollisionShape2D.set_deferred("disabled", false)
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
	$CollisionShape2D2.set_deferred("disabled", false)
	var glob = global_position
	reparent(self, get_node('/root/World'))
	position = glob
	thrown = true
	attached = false
	if animatedsprite.flip_h:
		velocity.x = -throwspeed- 200 
	else:
		velocity.x = throwspeed + 200
	velocity.y = -700 -throwspeed


func _on_Player_fliph(flipped):
	if flipped:
		animatedsprite.flip_h = true
		position.x = 10
	else:
		position.x = -10
		animatedsprite.flip_h = false


func _on_Player_moving():
	parentmoving = true


func _on_Player_stopped():
	parentmoving = false


func _on_AbilityArea_body_entered(body):
	if body.is_in_group("enemy"):
		firing = true
		if body.position.x < position.x:
			animatedsprite.flip_h = true
		else:
			animatedsprite.flip_h = false
		body.attacked()
		$firingtimer.start()


func _on_AbilityArea_area_entered(area):
	if area.is_in_group("button"):
		area.press()


func _on_firingtimer_timeout():
	firing = false
