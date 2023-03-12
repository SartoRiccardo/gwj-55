extends Node2D
class_name Dream


signal eaten(dream)


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
	queue_free()
