extends Node
class_name BaseState


var parent : Player = null


func init(parent_node : Player) -> void:
	parent = parent_node


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta : float) -> Player.State:
	return Player.State.NO_CHANGE


func _on_hurt(_enemy : Enemy) -> Player.State:
	return Player.State.NO_CHANGE
