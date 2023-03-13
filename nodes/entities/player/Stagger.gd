extends BaseState


func enter() -> void:
	parent.get_node("AnimatedSprite2D").play("hurt")
	parent.get_node("AnimationPlayer").play("invulnerable")


func exit() -> void:
	pass


func update(delta : float) -> Player.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -10*delta))
	return Player.State.NO_CHANGE
