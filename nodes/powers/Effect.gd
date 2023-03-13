extends Node2D
class_name Effect


@export var power_resource : PowerResource


func _ready():
	$Timer.timeout.connect(despawn)
	$Timer.start(power_resource.effect_duration)


func despawn():
	$HitBox.set_monitorable(false)
	queue_free()
