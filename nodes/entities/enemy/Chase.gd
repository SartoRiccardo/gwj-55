extends EnemyState
class_name EnemyChase


func enter() -> void:
	parent.get_node("Sprite").play("default")


func exit() -> void:
	pass


func update(delta : float) -> Enemy.State:
	var target := parent.target
	if target == null:
		parent.target = Utils.get_player()
		return Enemy.State.NO_CHANGE
	
	var direction := (target.global_position - parent.global_position).normalized()
	var target_velocity := direction * parent.max_speed
	parent.velocity = parent.velocity.move_toward(target_velocity, parent.ACCELERATION*delta)
	parent.adjust_sprite_flip(direction)
	
	return Enemy.State.NO_CHANGE

