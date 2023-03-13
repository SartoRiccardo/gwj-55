extends BaseState


func _on_hurt(enemy : Enemy) -> Player.State:
	if not parent.invulnerable:
		var stagger_direction := (parent.global_position - enemy.global_position).normalized()
		parent.velocity = stagger_direction * parent.STAGGER_SPEED
		enemy._on_successful_attack()
		return Player.State.STAGGER
	return super(enemy)
