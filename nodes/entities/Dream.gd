extends Node2D
class_name Dream


signal eaten(dream)

@export var powers : Array[PowerResource]

const SPAWN_ENEMY_CHANCE := 0.45
const ENEMY_SPAWNER := preload("res://nodes/entities/enemy/EnemySpawner.tscn")
const POWER_SPAWN_CHANCE := 0.25
const POWER_COLORS := {
	"dash": Color.BLUE_VIOLET,
	"explosion": Color.ORANGE_RED,
	"spore": Color.DARK_OLIVE_GREEN,
	"night_spell": Color.BLUE,
	"invisibility": Color.LIGHT_SLATE_GRAY,
}

var power : PowerResource = null
var edible := true


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
		chances.push_back(p.spawn_chance)
	power = Utils.rand_select(powers, chances)
	if power:
		$Glow.show()
		$Glow.set_modulate(POWER_COLORS[power.name])


func start_getting_eaten() -> void:
#	$DreamSprite.set_emitting(false)
	$DreamSprite.process_material.set_shader_parameter("is_going_to_target", true)
	$CollectTimer.start()


func set_eat_target(target : Vector2) -> void:
#	var target_local : Vector2 = target - $DreamSprite.global_position
	$DreamSprite.process_material.set_shader_parameter("target_location", target)


func stop_getting_eaten() -> void:
#	$DreamSprite.set_emitting(true)
	$DreamSprite.process_material.set_shader_parameter("is_going_to_target", false)
	$CollectTimer.stop()


func die(natural := true) -> void:
	edible = false
	$CollectArea.set_deferred("monitorable", false)
	$AnimationPlayer.play("despawn")
	if Utils.rng.randf() < SPAWN_ENEMY_CHANCE and natural:
		var enemy_root := get_tree().get_first_node_in_group("root_enemy")
		if enemy_root == null:
			enemy_root = get_parent()
		
		var spawner := ENEMY_SPAWNER.instantiate()
		spawner.global_position = global_position
		enemy_root.add_child(spawner)


func set_starting_point(point : Vector2) -> void:
	pass


func set_dream(dream_no : int) -> void:
	$DreamSprite/DreamInner.play("dream_%s" % dream_no)
