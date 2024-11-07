extends EnemyState

@export var idle_time_range := Vector2(1, 3)

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.state_timer.start(randf_range(idle_time_range.x, idle_time_range.y))


func _physics_update(delta: float) -> void:
	look_towards_target(true)

	if casted_owner.state_timer.is_stopped() or target_in_attack_range():
		_set_state("Finished")

	super(delta)


func _exit() -> void:
	pass


func _finish(data: Dictionary) -> void:
	finished.emit("Attacking", data)