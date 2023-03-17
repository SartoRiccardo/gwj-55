extends PanelContainer


func _ready():
	%Resume.pressed.connect(func() -> void:
		EventBus.game_unpause.emit()
	)
