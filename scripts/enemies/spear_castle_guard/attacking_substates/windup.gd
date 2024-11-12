extends EnemySubstate

@export var windup_time: float = 1.0

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("windup")
	casted_owner.substate_timer.start(windup_time)
	casted_owner.substate_timer.timeout.connect(_on_substate_timer_timeout)


func _update(_delta: float) -> void:
	pass


func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_on_substate_timer_timeout)


func _on_substate_timer_timeout() -> void:
	finished.emit("Charging")
