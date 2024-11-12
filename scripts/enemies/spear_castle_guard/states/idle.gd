extends EnemyState

@export var idle_time_range := Vector2(1, 3)

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.state_timer.start(randf_range(idle_time_range.x, idle_time_range.y))
	casted_owner.state_timer.timeout.connect(_on_state_timer_timeout)


func _physics_update(delta: float) -> void:
	look_towards_target(true)

	if target_in_attack_range():
		_set_state("Finished")

	super(delta)


func _exit() -> void:
	casted_owner.state_timer.timeout.disconnect(_on_state_timer_timeout)


func _finish(data: Dictionary) -> void:
	finished.emit("Attacking", data)


func _on_state_timer_timeout() -> void:
	_set_state("Finished")
