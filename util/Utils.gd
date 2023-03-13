extends Node

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()


func get_player() -> Player:
	var player : Player = get_tree().get_first_node_in_group("playable")
	return player
