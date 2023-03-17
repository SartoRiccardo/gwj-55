extends Node
class_name CenterPivot


func _process(delta):
	var parent : Control = get_parent()
	parent.pivot_offset = parent.size/2.0
