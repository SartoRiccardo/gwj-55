extends BaseState


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta : float) -> String:
	_update_velocity(delta)
	_update_sprite()
	
	if Input.is_action_pressed("eat"):
		var dream_areas : Array[Area2D] = parent.get_node("EatRange").get_overlapping_areas()
		if dream_areas.size() > 0:
			var dream : Dream = dream_areas[0].get_parent()
			parent.current_dream = dream
			return "eating"
	
	return NO_CHANGE

func _update_velocity(delta : float) -> void:
	if parent.direction == Vector2.ZERO:
		parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -15*delta))
	else:
		var target_velocity : Vector2 = (parent.direction * parent.MAX_SPEED).limit_length(parent.MAX_SPEED)
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
		Vector2.UP+Vector2.LEFT, \
		Vector2.UP+Vector2.RIGHT:
			sprite.play("go_up_left")
		Vector2.DOWN:
			sprite.play("go_down")
		Vector2.DOWN+Vector2.LEFT, \
		Vector2.DOWN+Vector2.RIGHT:
			sprite.play("go_down_left")
	
	if parent.direction != Vector2.ZERO:
		sprite.set_flip_h(sign(parent.direction.x) == sign(Vector2.RIGHT.x))
