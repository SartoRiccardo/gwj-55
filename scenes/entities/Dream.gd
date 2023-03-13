extends Node2D
class_name Dream


signal eaten(dream)

const SPAWN_ENEMY_CHANCE := 0.35
const ENEMY_SPAWNER := preload("res://scenes/entities/enemy/EnemySpawner.tscn")


func _ready():
	$CollectTimer.timeout.connect(func ():
		emit_signal("eaten", self)
	)


func _process(delta):
	pass


func start_eating():
	$CollectTimer.start()


func stop_eating():
	$CollectTimer.stop()


func die():
	if Utils.rng.randf() < SPAWN_ENEMY_CHANCE:
		var enemy_root := get_tree().get_first_node_in_group("root_enemy")
		if enemy_root == null:
			enemy_root = get_parent()
		
		var spawner := ENEMY_SPAWNER.instantiate()
		spawner.global_position = global_position
		enemy_root.add_child(spawner)
	queue_free()
