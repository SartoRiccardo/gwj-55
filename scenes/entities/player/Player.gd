extends Node2D
class_name Player

@export var invulnerable := false

enum State { CONTROLLABLE, EAT, STAGGER, DASH, CHARGE, NO_CHANGE }

const MAX_SPEED := 400.0
const STAGGER_SPEED := 700.0
const ACCELERATION := MAX_SPEED*7

var inputs : Array[String]= []
var direction := Vector2.ZERO
var velocity := Vector2.ZERO
var current_dream : Dream = null
var current_power : PowerResource = preload("res://resources/powers/Explosion.tres")
var power_callbacks := {
	"explosion": _spawn_explosion,
	"dash": _start_dash,
	"night_spell": _cast_night_spell,
	"invisibility": _go_invisible,
	"spore": _spawn_spores,
}

@onready var states := {
	State.CONTROLLABLE: $States/Controllable,
	State.EAT: $States/Eating,
	State.STAGGER: $States/Stagger,
	State.DASH: $States/Dashing,
	State.CHARGE: $States/Charging,
}
@onready var current_state : BaseState = states[State.CONTROLLABLE]


func _ready():
	for state in $States.get_children():
		state.init(self)
	current_state.enter()
	
	$HurtBox.area_entered.connect(func (a2d : Area2D):
		if a2d.get_parent() is Enemy:
			var new_state := current_state._on_hurt(a2d.get_parent())
			_change_state(new_state)
	)


func _process(delta):
	direction = get_direction()
	var new_state := current_state.update(delta)
	_change_state(new_state)
	
	global_position += velocity * delta


func _change_state(new_state : Player.State) -> void:
	if new_state not in states.keys():
		return
	
	var state_node : BaseState = states[new_state]
	if state_node == current_state:
		return
	current_state.exit()
	state_node.enter()
	current_state = state_node


func get_direction() -> Vector2:
	var events_to_check : Array[String] = ["go_left", "go_right", "go_down", "go_up"]
	for event in events_to_check:
		if Input.is_action_just_released(event) or Input.is_action_just_pressed(event):
			inputs.erase(event)
		if Input.is_action_just_pressed(event):
			inputs.push_front(event)
	
	var direction : Vector2 = Vector2.ZERO
	for input in inputs:
		if input == "go_left" and direction.x == 0:
			direction += Vector2.LEFT
		elif input == "go_right" and direction.x == 0:
			direction += Vector2.RIGHT
		
		if input == "go_up" and direction.y == 0:
			direction += Vector2.UP
		elif input == "go_down" and direction.y == 0:
			direction += Vector2.DOWN
	
	return direction


func stop_stagger() -> void:
	_change_state(State.CONTROLLABLE)


func use_power() -> void:
	if current_power == null or not (current_power.name in power_callbacks.keys()):
		return
	power_callbacks[current_power.name].call()
	current_power = null


func _spawn_explosion() -> void:
	pass


func _start_dash() -> void:
	_change_state(State.DASH)


func _spawn_spores() -> void:
	pass


func _cast_night_spell() -> void:
	pass


func _go_invisible() -> void:
	pass
