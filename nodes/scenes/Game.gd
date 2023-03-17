extends Node2D
class_name Game


@onready var GAME_LENGTH : float = $Timer.wait_time
const NIGHT_SPELL_INCREASE := 30.0

var dreams : int = 0
var animating_time := false


func _ready():
	$Timer.timeout.connect(end_game)
	EventBus.dreams_earned.connect(_on_dream_earned)
	EventBus.dreams_stolen.connect(_on_dream_stolen)
	EventBus.extend_night.connect(_extend_night)
	start_game()


func _process(_delta):
	if not animating_time:
		$GameUI.set_time_left($Timer.time_left/GAME_LENGTH)


func start_game() -> void:
	$Timer.start(GAME_LENGTH)


func end_game() -> void:
	EventBus.game_finished.emit()


func _on_dream_earned() -> void:
	dreams += 1
	$GameUI.set_dreams(dreams)


func _on_dream_stolen() -> void:
	dreams = max(0, dreams-3)
	$GameUI.set_dreams(dreams)


func _extend_night() -> void:
	animating_time = true
	var new_time : float = min(GAME_LENGTH, $Timer.time_left + NIGHT_SPELL_INCREASE)
	$GameUI.increase_time(new_time/GAME_LENGTH)
	
	await $GameUI.time_animation_finished
	$Timer.start(new_time)
	animating_time = false
