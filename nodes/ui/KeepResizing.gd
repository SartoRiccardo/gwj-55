extends Control


@export var resize_x := true
@export var resize_y := true


func _process(delta):
	if resize_x:
		size.x = 0
	if resize_y:
		size.y = 0
