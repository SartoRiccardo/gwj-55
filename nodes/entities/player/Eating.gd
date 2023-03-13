extends "Hurtable.gd"


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


func update(delta : float) -> Player.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -20*delta))
	
	if not Input.is_action_pressed("eat") or parent.current_dream == null:
		return Player.State.CONTROLLABLE
	
	return Player.State.NO_CHANGE


func _eat_dream(_dream : Dream):
	EventBus.dreams_earned.emit()
	if parent.current_dream.power:
		parent.current_power = parent.current_dream.power
	parent.current_dream.die()
