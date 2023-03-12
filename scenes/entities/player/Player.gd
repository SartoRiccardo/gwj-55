extends Node2D
class_name Player


const MAX_SPEED : float = 400
const ACCELERATION : float = MAX_SPEED*7

var inputs : Array[String]= []
var direction : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2.ZERO
var current_dream : Dream = null

@onready var states : Dictionary = {
	"controllable": $States/Controllable,
	"eating": $States/Eating,
}
@onready var current_state : BaseState = states["controllable"]


func _ready():
	for state in $States.get_children():
		state.init(self)
	current_state.enter()


func _process(delta):
	direction = get_direction()
	var new_state : String = current_state.update(delta)
	_change_state(new_state)
	
	global_position += velocity * delta


func _change_state(new_state : String) -> void:
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
