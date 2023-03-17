extends Node
class_name Root


func _ready():
	pass


func change_scene(new_scene : Node):
	for child in $View.get_children():
		child.queue_free()
	$View.add_child(new_scene)
