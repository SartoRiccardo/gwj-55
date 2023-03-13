extends Node

var rng : RandomNumberGenerator


func _ready():
	rng = RandomNumberGenerator.new()


func get_player() -> Player:
	var player : Player = get_tree().get_first_node_in_group("playable")
	return player


func rand_select(values: Array, probabilities : Array[float]):
	var roll := rng.randf()
	var cumulative := 0.0
	for i in min(probabilities.size(), values.size()):
		if cumulative <= roll and roll < probabilities[i]+cumulative:
			return values[i]
		cumulative += probabilities[i]
	
	return null
