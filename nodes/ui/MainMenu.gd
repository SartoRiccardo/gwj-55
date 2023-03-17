extends CanvasLayer
class_name MainMenu


@export var scene_game : PackedScene = null
@export var scene_credits : PackedScene = null
@export var scene_settings : PackedScene = null


func _ready():
	%Start.pressed.connect(func() -> void: self.change_scene(scene_game))
	%Settings.pressed.connect(func() -> void: self.change_scene(scene_settings))
	%Credits.pressed.connect(func() -> void: self.change_scene(scene_credits))
	%Quit.pressed.connect(func() -> void: get_tree().quit())


func change_scene(scene : PackedScene) -> void:
	var root := get_tree().get_first_node_in_group("root")
	if root:
		var node := scene.instantiate()
		root.change_scene(node)
