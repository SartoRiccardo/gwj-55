extends Node
class_name BaseState


const NO_CHANGE : String = "_no_change"

var parent : Player = null


func init(parent_node : Player) -> void:
	parent = parent_node


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta : float) -> String:
	return NO_CHANGE
