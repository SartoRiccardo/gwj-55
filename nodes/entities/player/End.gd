extends BaseState
class_name PlayerEnd


func enter() -> void:
	parent.get_node("HitBox").set_monitorable(false)
	parent.get_node("HurtBox").set_monitoring(false)
	parent.get_node("AnimatedSprite2D").play("idle")


func exit() -> void:
	pass


func update(delta : float) -> Player.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -15*delta))
	return Player.State.NO_CHANGE
