extends EnemySubstate

@export var recovery_time: float = 0.3

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("recovery")
	casted_owner.substate_timer.start(recovery_time)


func _physics_update(_delta: float) -> void:
	if casted_owner.substate_timer.is_stopped():
		look_towards_target(false)
		finished.emit("Finished")


func _exit() -> void:
	pass


func _hit(data: Dictionary):
	finished.emit("Hit", data)
