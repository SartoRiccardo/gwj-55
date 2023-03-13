extends Node2D
class_name Enemy

# The max speed the enemies can go at will be randomized
const MIN_MAX_SPEED := 75.0
const MAX_MAX_SPEED := 150.0
const ACCELERATION := 1000.0

var target : Player = null
var rng : RandomNumberGenerator
var max_speed : float
var velocity := Vector2.ZERO


func _ready():
	rng = RandomNumberGenerator.new()
	max_speed = rng.randf_range(MIN_MAX_SPEED, MAX_MAX_SPEED)


func _process(delta):
	if target == null:
		target = Utils.get_player()
		return
	
	var direction := (target.global_position - global_position).normalized()
	var target_velocity := direction * max_speed
	velocity = velocity.move_toward(target_velocity, ACCELERATION*delta)
	global_position += velocity * delta


func _on_successful_attack() -> void:
	EventBus.emit_signal("dreams_stolen")
	queue_free()
