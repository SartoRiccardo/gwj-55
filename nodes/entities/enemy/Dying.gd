extends EnemyState
class_name EnemyDying


func enter() -> void:
	parent.velocity = Vector2.ZERO
