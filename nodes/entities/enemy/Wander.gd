extends EnemyState
class_name EnemyWander


const MIN_IDLE_TIME := 2.0
const MAX_IDLE_TIME := 4.0
const IDLE_SPEED := 300.0


func init(parent_node : Enemy) -> void:
	super(parent_node)
	$Timer.timeout.connect(start_wander)


func enter() -> void:
	$Timer.start(Utils.rng.randf_range(MIN_IDLE_TIME, MAX_IDLE_TIME))


func exit() -> void:
	$Timer.stop()


func update(delta : float) -> Enemy.State:
	parent.velocity = (Vector2.ZERO).lerp(parent.velocity, pow(2, -10*delta))
	
	return Enemy.State.NO_CHANGE


func start_wander() -> void:
	var angle := Utils.rng.randf_range(0, PI*2)
	var direction := Vector2(sin(angle), cos(angle))
	parent.velocity = direction * IDLE_SPEED
	
	$Timer.start(Utils.rng.randf_range(MIN_IDLE_TIME, MAX_IDLE_TIME))
