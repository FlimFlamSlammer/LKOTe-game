extends EnemyState

@export var distance_to_stop: float = 100.0
@export var idle_time: float = 4.0

func _enter(previous_state_path: NodePath, data: Dictionary = {}) -> void:
	casted_owner.state_timer.start(idle_time)
	casted_owner.state_timer.connect("timeout", _on_state_timer_timeout)
	super(previous_state_path, data)


func _physics_update(delta: float) -> void:
	if not (substate is EnemyDodgeState):
		if absf(get_target_relative_position().x) > 100.0:
			_set_state("Finished")
		if casted_owner.wall_ray_cast.is_colliding():
			casted_owner.direction = -casted_owner.direction
	super(delta)


func _exit() -> void:
	pass


func _finish(data: Dictionary) -> void:
	finished.emit("Idle", data)


## Calls [code]_set_state("Finished")[/code] if [code]substate != "Dodging"[/code].
func _on_state_timer_timeout() -> void:
	if not (substate is EnemyDodgeState):
		_set_state("Finished")