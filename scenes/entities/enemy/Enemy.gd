extends Node2D
class_name Enemy


enum State { CHASE, WANDER, ASLEEP, NO_CHANGE }

# The max speed the enemies can go at will be randomized
const MIN_MAX_SPEED := 75.0
const MAX_MAX_SPEED := 150.0
const ACCELERATION := 1000.0

var target : Player = null
var rng : RandomNumberGenerator
var max_speed : float
var velocity := Vector2.ZERO

@onready var states = {
	State.CHASE: $States/Chase,
	State.ASLEEP: $States/Asleep,
	State.WANDER: $States/Wander,
}
@onready var current_state : EnemyState = states[State.CHASE]


func _ready():
	rng = RandomNumberGenerator.new()
	max_speed = rng.randf_range(MIN_MAX_SPEED, MAX_MAX_SPEED)
	
	for state in $States.get_children():
		state.init(self)
	current_state.enter()
	
	$HurtBox.area_entered.connect(func(a2d : Area2D):
		var collider = a2d.get_parent()
		if collider is Spore:
			_change_state.call_deferred(State.ASLEEP)
		else:
			die()
	)
	EventBus.player_invisible.connect(func():
		self._change_state.call_deferred(State.WANDER)
	)
	EventBus.player_visible.connect(func():
		self._change_state.call_deferred(State.CHASE)
	)


func _process(delta):
	var new_state := current_state.update(delta)
	_change_state(new_state)
	global_position += velocity * delta


func _change_state(new_state : State) -> void:
	if new_state not in states.keys():
		return
	
	var state : EnemyState = states[new_state]
	if state == current_state:
		return
	current_state.exit()
	state.enter()
	current_state = state


func die() -> void:
	queue_free()


func wake_up() -> void:
	_change_state(State.CHASE)


func _on_successful_attack() -> void:
	EventBus.emit_signal("dreams_stolen")
	queue_free()
