extends BaseState


func enter() -> void:
	if parent.current_dream == null:
		return
	parent.current_dream.start_eating()
	parent.current_dream.eaten.connect(_eat_dream)
	parent.get_node("AnimatedSprite2D").play("eat")


func exit() -> void:
	if parent.current_dream and is_instance_valid(parent.current_dream):
		parent.current_dream.stop_eating()
		parent.current_dream.eaten.disconnect(_eat_dream)
	parent.current_dream = null


func update(delta : float) -> String:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -20*delta))
	
	if not Input.is_action_pressed("eat") or parent.current_dream == null:
		return "controllable"
	
	return NO_CHANGE


func _eat_dream(_dream : Dream):
	parent.current_dream.die()
