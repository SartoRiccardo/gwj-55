extends Node
class_name EnemyState


var parent : Enemy = null


func init(parent_node : Enemy) -> void:
	parent = parent_node


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta : float) -> Enemy.State:
	return Enemy.State.NO_CHANGE
