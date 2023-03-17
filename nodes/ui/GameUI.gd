extends CanvasLayer
class_name GameUI


signal time_animation_finished

const TIME_TOTAL := 7 * 60

var ingame_time_passed := 400.0


func _ready() -> void:
	EventBus.gain_power.connect(set_power)
	EventBus.lose_power.connect(remove_power)
	$Margin1/VBox1/HBox1/Button.pressed.connect(func() -> void:
		$PauseContainer.show()
		EventBus.game_pause.emit()
		get_tree().paused = true
	)
	EventBus.game_unpause.connect(func() -> void:
		$PauseContainer.hide()
		get_tree().paused = false
	)


func _process(_delta : float) -> void:
	var hours := int(ingame_time_passed/60 + 23)
	%TimeLeft.set_text("%02d:%02d" % [hours % 24, int(ingame_time_passed-(hours-23)*60)])	


func increase_time(new_percent_left : float) -> void:
	var new_ingame_time_passed := (1-new_percent_left) * TIME_TOTAL
	
	var tween := get_tree().create_tween()
	tween.tween_property(self, "ingame_time_passed", new_ingame_time_passed,
		%AnimationTime.get_animation("night_spell").length
	)
	%AnimationTime.play("night_spell")
	
	await %AnimationTime.animation_finished
	time_animation_finished.emit()


func set_time_left(percent_left : float) -> void:
	ingame_time_passed = (1-percent_left) * TIME_TOTAL


func set_dreams(dreams : int) -> void:
	if dreams > int(%Points.text):
		%AnimationPoints.play("gain")
	else:
		%AnimationPoints.play("lose")
	%Points.set_text(str(dreams))


func set_power(power : PowerResource) -> void:
	%PowerIcon.set_texture(power.texture)
	%Description.set_text(power.power_description)
	%AnimationPower.play("get_power")


func remove_power() -> void:
	%AnimationPower.play("use_power")
