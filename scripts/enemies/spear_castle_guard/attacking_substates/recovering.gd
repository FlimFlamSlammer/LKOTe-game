extends EnemySubstate

@export var recovery_time: float = 0.3

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("recovery")
	casted_owner.substate_timer.start(recovery_time)
	casted_owner.substate_timer.timeout.connect(_finish)


func _update(_delta: float) -> void:
	pass


func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish():
	look_towards_target(false)
	finished.emit("Finished")
