extends Camera2D


var player_to_follow : Player = null


func _ready():
	player_to_follow = Utils.get_player()


func _process(delta):
	if player_to_follow == null:
		player_to_follow = Utils.get_player()
		return
	
	global_position = player_to_follow.global_position.lerp(global_position, pow(2, -20*delta))
