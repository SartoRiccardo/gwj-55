extends CanvasLayer
class_name GameUI


@onready var label_time = $Margin1/VBox1/HBox1/VBox1/HBox2/TimeLeft
@onready var label_points = $Margin1/VBox1/HBox1/VBox1/HBox1/Points
@onready var label_power = $Margin1/VBox1/HBox2/Power

const TIME_TOTAL := 7 * 60


func _ready() -> void:
	EventBus.gain_power.connect(set_power)
	EventBus.lose_power.connect(remove_power)


func set_time_left(percent_left : float) -> void:
	var ingame_time_left := (1-percent_left) * TIME_TOTAL
	var hours := int(ingame_time_left/60 + 23)
	label_time.set_text("%02d:%02d" % [hours % 24, int(ingame_time_left-(hours-23)*60)])


func set_dreams(dreams : int) -> void:
	label_points.set_text(str(dreams))


func set_power(power : PowerResource) -> void:
	label_power.set_text(power.full_name)


func remove_power() -> void:
	label_power.set_text("")
