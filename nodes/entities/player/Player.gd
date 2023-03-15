extends CharacterBody2D
class_name Player

@export var invulnerable := false

enum State { CONTROLLABLE, EAT, STAGGER, DASH, CHARGE, NO_CHANGE, END }

const MAX_SPEED := 400.0
const STAGGER_SPEED := 700.0
const ACCELERATION := MAX_SPEED*7
const SCENE_EXPOLOSION := preload("res://nodes/powers/Explosion.tscn")
const SCENE_SPORE := preload("res://nodes/powers/Spore.tscn")

var inputs : Array[String]= []
var direction := Vector2.ZERO
#var velocity := Vector2.ZERO
var current_dream : Dream = null
var current_power : PowerResource = null
var power_callbacks := {
	"explosion": func(): _spawn_effect(SCENE_EXPOLOSION),
	"dash": _start_dash,
	"night_spell": _cast_night_spell,
	"invisibility": _go_invisible,
	"spore": func(): _spawn_effect(SCENE_SPORE),
}

@onready var states := {
	State.CONTROLLABLE: $States/Controllable,
	State.EAT: $States/Eating,
	State.STAGGER: $States/Stagger,
	State.DASH: $States/Dashing,
	State.CHARGE: $States/Charging,
	State.END: $States/End,
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
	$Invisibility.timeout.connect(_go_visible)
	EventBus.game_finished.connect(_on_game_finished)


func _process(delta):
	check_inputs()
	var new_state := current_state.update(delta)
	_change_state(new_state)
	
	move_and_slide()
#	global_position += velocity * delta


func _change_state(new_state : Player.State) -> void:
	if new_state not in states.keys():
		return
	
	var state_node : BaseState = states[new_state]
	if state_node == current_state:
		return
	current_state.exit()
	state_node.enter()
	current_state = state_node


func check_inputs() -> void:
	var events_to_check : Array[String] = ["go_left", "go_right", "go_down", "go_up"]
	for event in events_to_check:
		if Input.is_action_just_released(event) or Input.is_action_just_pressed(event):
			inputs.erase(event)
		if Input.is_action_just_pressed(event):
			inputs.push_front(event)


func get_direction() -> Vector2:
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
	
	var angle := 0.0
	match direction:
		Vector2.DOWN+Vector2.LEFT:
			angle = PI-PI/6
		Vector2.DOWN+Vector2.RIGHT:
			angle = PI/6
		Vector2.UP+Vector2.LEFT:
			angle = PI+PI/6
		Vector2.UP+Vector2.RIGHT:
			angle = -PI/6
	if angle:
		direction = Vector2(cos(angle), sin(angle))
	
	return direction.normalized()


func stop_stagger() -> void:
	_change_state(State.CONTROLLABLE)


func use_power() -> void:
	if current_power == null or not (current_power.name in power_callbacks.keys()):
		return
	power_callbacks[current_power.name].call()
	current_power = null
	EventBus.lose_power.emit()


func _spawn_effect(effect_scn : PackedScene) -> void:
	var power_root := get_tree().get_first_node_in_group("root_power_fx")
	if power_root == null:
		power_root = get_parent()
	var effect := effect_scn.instantiate()
	effect.global_position = global_position
	power_root.add_child(effect)


func _start_dash() -> void:
	_change_state(State.DASH)


func _cast_night_spell() -> void:
	EventBus.extend_night.emit()


func _go_invisible() -> void:
	$Invisibility.start(current_power.effect_duration)
	$AnimatedSprite2D.modulate.a = 0.2
	EventBus.player_invisible.emit()


func _go_visible() -> void:
	$AnimatedSprite2D.modulate.a = 1.0
	EventBus.player_visible.emit()


func is_invisible() -> bool:
	return $Invisibility.time_left > 0


func _on_game_finished() -> void:
	$States/Controllable.end = true
