extends BaseState


const DASH_SPEED := 2000

var next_state := Player.State.NO_CHANGE


func init(parent_node : Player) -> void:
	$Timer.timeout.connect(func():
		next_state = Player.State.CONTROLLABLE
	)
	super(parent_node)


func enter() -> void:
	next_state = Player.State.NO_CHANGE
	$Timer.start(parent.current_power.effect_duration)
	parent.get_node("HitBox").set_monitorable(true)
	parent.get_node("HurtBox").set_monitoring(false)


func exit() -> void:
	parent.get_node("HitBox").set_monitorable(false)
	parent.get_node("HurtBox").set_monitoring(true)


func update(_delta : float) -> Player.State:
	parent.velocity = parent.velocity.normalized() * DASH_SPEED
	return next_state
