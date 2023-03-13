extends Node2D


@export var house_data : HouseResource

const MIN_SPAWN_DELAY : float = 3.0
const MAX_SPAWN_DELAY : float = 5.5
const DREAM_SCENE : PackedScene = preload("res://scenes/entities/Dream.tscn")

var rng : RandomNumberGenerator
var dreams : Array[Dream]


func _ready():
	if house_data == null:
		queue_free()
	$House.set_texture(house_data.house_texture)
	dreams = []
	for _i in 3:
		dreams.push_front(null)
	rng = RandomNumberGenerator.new()
	
	$SpawnTimer.timeout.connect(func(): spawn_dream())


func _process(delta):
	_start_dream_spawn()


func dream_count() -> int:
	return dreams.reduce(func(accum, dream):
		return accum+1 if dream else accum,
		0
	)


func spawn_dream():
	var root_dreams : Node = get_tree().get_first_node_in_group("root_dreams")
	if root_dreams == null:
		root_dreams = get_parent()
	var new_dream : Dream = DREAM_SCENE.instantiate()
	new_dream.eaten.connect(_on_dream_eaten)
	var dream_idx : int = _get_empty_dream_spot()
	if dream_idx == -1:
		return
	
	var dream_pos = _get_dream_position(dream_idx)
	new_dream.global_position = dream_pos
	dreams[dream_idx] = new_dream
	root_dreams.add_child(new_dream)


func _start_dream_spawn():
	if dream_count() < house_data.max_dreams and $SpawnTimer.is_stopped():
		$SpawnTimer.start(rng.randf_range(MIN_SPAWN_DELAY, MAX_SPAWN_DELAY))


func _get_empty_dream_spot() -> int:
	var spots : Array[int] = []
	for i in dreams.size():
		if dreams[i] == null:
			spots.push_back(i)
	if spots.size() == 0:
		return -1
	return spots[rng.randi_range(0, spots.size()-1)]


func _get_dream_position(dream_idx : int) -> Vector2:
	var pos : Vector2 = Vector2.ZERO
	if $DreamPositions.get_child_count() > dream_idx:
		return $DreamPositions.get_child(dream_idx).global_position
	return pos


func _on_dream_eaten(dream : Dream) -> void:
	var dream_idx : int = dreams.find(dream)
	dreams[dream_idx] = null
