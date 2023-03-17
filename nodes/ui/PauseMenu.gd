extends PanelContainer


var scene_main_menu_path : String = "res://nodes/ui/MainMenu.tscn"
var scene_main_menu : PackedScene = null


func _ready():
	scene_main_menu = load(scene_main_menu_path)
	
	%Resume.pressed.connect(func() -> void:
		EventBus.game_unpause.emit()
	)
	%Menu.pressed.connect(func() -> void:
		EventBus.game_unpause.emit()
		var root := get_tree().get_first_node_in_group("root")
		if root:
			var node := scene_main_menu.instantiate()
			root.change_scene(node)
	)
