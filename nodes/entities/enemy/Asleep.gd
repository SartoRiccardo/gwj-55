extends EnemyState
class_name EnemyAsleep


const MIN_SLEEP_TIME := 6.0
const MAX_SLEEP_TIME := 10.0


func init(parent_node : Enemy) -> void:
	super(parent_node)
	$SleepTimer.timeout.connect(parent.wake_up)


func enter() -> void:
	parent.get_node("Sprite").play("asleep")
	$SleepTimer.start(Utils.rng.randf_range(MIN_SLEEP_TIME, MAX_SLEEP_TIME))
	parent.get_node("HitBox").set_monitorable(false)


func exit() -> void:
	$SleepTimer.stop()
	parent.get_node("HitBox").set_monitorable(true)


func update(delta : float) -> Enemy.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -15*delta))
	return Enemy.State.NO_CHANGE

