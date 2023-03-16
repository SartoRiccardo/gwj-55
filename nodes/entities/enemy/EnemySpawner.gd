extends Node2D
class_name EnemySpawner


const ENEMY_SCENE := preload("res://nodes/entities/enemy/Enemy.tscn")
const ROTATE_SPEED := 2*PI / 12.0


func _ready() -> void:
	$SpawnTimer.timeout.connect(spawn_enemy)


func _process(delta : float) -> void:
	$CanvasGroup/Spiral1.rotation += delta * ROTATE_SPEED
	$CanvasGroup/Spiral2.rotation -= delta * ROTATE_SPEED


func spawn_enemy() -> void:
	var enemy_root := get_tree().get_first_node_in_group("root_enemy")
	if enemy_root == null:
		enemy_root = get_parent()
	
	var enemy := ENEMY_SCENE.instantiate()
	enemy.global_position = global_position
	enemy_root.add_child(enemy)
	$AnimationPlayer.play("despawn")
