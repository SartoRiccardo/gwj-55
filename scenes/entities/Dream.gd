extends Node2D
class_name Dream


signal eaten(dream)

@export var powers : Array[PowerResource]

const SPAWN_ENEMY_CHANCE := 0.35
const ENEMY_SPAWNER := preload("res://scenes/entities/enemy/EnemySpawner.tscn")
const POWER_SPAWN_CHANCE := 0.5

var power : PowerResource = null


func _ready():
	_select_power()
	
	$CollectTimer.timeout.connect(func ():
		eaten.emit(self)
	)


func _process(delta):
	pass


func _select_power() -> void:
	if Utils.rng.randf() > POWER_SPAWN_CHANCE:
		return
	
	var chances : Array[float] = []
	for p in powers:
		chances.push_front(p.spawn_chance)
	power = Utils.rand_select(powers, chances)
	$Label.text = power.name


func start_eating() -> void:
	$CollectTimer.start()


func stop_eating() -> void:
	$CollectTimer.stop()


func die(natural := true) -> void:
	if Utils.rng.randf() < SPAWN_ENEMY_CHANCE and natural:
		var enemy_root := get_tree().get_first_node_in_group("root_enemy")
		if enemy_root == null:
			enemy_root = get_parent()
		
		var spawner := ENEMY_SPAWNER.instantiate()
		spawner.global_position = global_position
		enemy_root.add_child(spawner)
	queue_free()
