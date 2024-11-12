extends EnemyState

@export var distance_to_stop: float = 100.0
@export var idle_time: float = 4.0

var has_finished: bool

func _enter(previous_state_path: NodePath, data: Dictionary = {}) -> void:
	has_finished = false
	casted_owner.state_timer.start(idle_time)
	casted_owner.state_timer.timeout.connect(_on_state_timer_timeout)
	super(previous_state_path, data)


func _physics_update(delta: float) -> void:
	if not (substate is EnemyDodgeState):
		var x_distance = absf(get_target_relative_position().x)
		if has_finished or x_distance > 100.0:
			_set_state("Finished")
		if casted_owner.wall_ray_cast.is_colliding():
			casted_owner.direction = -casted_owner.direction
	super(delta)


func _exit() -> void:
	casted_owner.state_timer.timeout.disconnect(_on_state_timer_timeout)


func _finish(data: Dictionary) -> void:
	finished.emit("Idle", data)


func _on_state_timer_timeout() -> void:
	has_finished = true
