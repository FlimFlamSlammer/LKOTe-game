extends EnemySubstate

@export var stun_time: float = 2.0

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("stunned")

	casted_owner.substate_timer.start(stun_time)
	casted_owner.substate_timer.timeout.connect(_finish)


func _update(_delta: float) -> void:
	pass


func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish():
	look_towards_target(true)
	finished.emit("Finished")
