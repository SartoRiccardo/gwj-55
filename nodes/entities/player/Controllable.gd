extends "Hurtable.gd"


var end := false


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta : float) -> Player.State:
	if end:
		return Player.State.END
	
	parent.direction = parent.get_direction()
	_update_velocity(delta)
	_update_sprite()
	
	if Input.is_action_pressed("eat"):
		var dream_areas : Array[Area2D] = parent.get_node("EatRange").get_overlapping_areas()
		if dream_areas.size() > 0:
			for d in dream_areas:
				var dream : Dream = d.get_parent()
				if dream.edible:
					parent.current_dream = dream
					return Player.State.EAT
	
	if Input.is_action_pressed("action") and parent.current_power:
		if parent.current_power.charge_duration > 0:
			return Player.State.CHARGE
		else:
			parent.use_power()
	
	return Player.State.NO_CHANGE


func _update_velocity(delta : float) -> void:
	if parent.direction == Vector2.ZERO:
		parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -15*delta))
	else:
		var target_velocity := parent.direction.normalized() * parent.MAX_SPEED
		parent.velocity = parent.velocity.move_toward(target_velocity, delta*parent.ACCELERATION)


func _update_sprite() -> void:
	var sprite : AnimatedSprite2D = parent.get_node("AnimatedSprite2D")
	match parent.direction:
		Vector2.ZERO:
			sprite.play("idle")
		Vector2.LEFT, \
		Vector2.RIGHT:
			sprite.play("go_left")
		Vector2.UP:
			sprite.play("go_up")
		Vector2(cos(PI+PI/6), sin(PI+PI/6)), \
		Vector2(cos(-PI/6), sin(-PI/6)):
			sprite.play("go_up_left")
		Vector2.DOWN:
			sprite.play("go_down")
		Vector2(cos(PI/6), sin(PI/6)), \
		Vector2(cos(PI-PI/6), sin(PI-PI/6)):
			sprite.play("go_down_left")
	
	if parent.direction != Vector2.ZERO:
		sprite.set_flip_h(sign(parent.direction.x) == sign(Vector2.RIGHT.x))
