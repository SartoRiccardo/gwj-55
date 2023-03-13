extends Node2D
class_name EnemySpawner


const ENEMY_SCENE := preload("res://scenes/entities/enemy/Enemy.tscn")


func spawn_enemy() -> void:
	var enemy_root := get_tree().get_first_node_in_group("root_enemy")
	if enemy_root == null:
		enemy_root = get_parent()
	
	var enemy := ENEMY_SCENE.instantiate()
	enemy.global_position = global_position
	enemy_root.add_child(enemy)
