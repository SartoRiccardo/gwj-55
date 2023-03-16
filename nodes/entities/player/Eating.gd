extends "Hurtable.gd"


@export var eat_target : Vector2 = Vector2.ZERO

var dream_eaten := false
var player_sprite : AnimationComposite = null


func enter() -> void:
	dream_eaten = false
	if parent.current_dream == null:
		return
	parent.current_dream.start_getting_eaten()
	parent.current_dream.eaten.connect(_eat_dream)
	player_sprite = parent.get_node("Sprite")
	player_sprite.set_flip_h(parent.current_dream.global_position.x > parent.global_position.x)
	player_sprite.play("eat")


func exit() -> void:
	if parent.current_dream and is_instance_valid(parent.current_dream):
		parent.current_dream.stop_getting_eaten()
		parent.current_dream.eaten.disconnect(_eat_dream)
	parent.current_dream = null


func update(delta : float) -> Player.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -20*delta))
	if is_instance_valid(parent.current_dream):
		var target := Vector2(eat_target)
		if player_sprite.is_flipped_h():
			target.x *= -1
		var eat_position := parent.to_global(target)
		parent.current_dream.set_eat_target(eat_position)
	
	if not Input.is_action_pressed("eat") or parent.current_dream == null or dream_eaten:
		return Player.State.CONTROLLABLE
	
	return Player.State.NO_CHANGE


func _eat_dream(_dream : Dream):
	EventBus.dreams_earned.emit()
	if parent.current_dream.power:
		var power := parent.current_dream.power
		parent.current_power = power
		EventBus.gain_power.emit(power)
	parent.current_dream.die()
	dream_eaten = true
