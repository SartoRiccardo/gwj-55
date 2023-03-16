extends "Hurtable.gd"


const CHARGE_STAGES := 3

var stage := 0


func init(parent_node : Player) -> void:
	$Timer.timeout.connect(on_charge_stage_change)
	super(parent_node)


func enter() -> void:
	stage = 0
	parent.get_node("Sprite").play("charge_%s" % stage)
	$Timer.start(parent.current_power.charge_duration/3.0)


func exit() -> void:
	$Timer.stop()


func update(delta : float) -> Player.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -15*delta))
	
	if not Input.is_action_pressed("action") or parent.current_power == null:
		return Player.State.CONTROLLABLE
	
	return Player.State.NO_CHANGE


func on_charge_stage_change() -> void:
	stage += 1
	if stage < CHARGE_STAGES:
		parent.get_node("Sprite").play("charge_%s" % stage)
		$Timer.start(parent.current_power.charge_duration/3.0)
	else:
		parent.use_power()
