extends EnemySubstate

@export var stun_time: float = 1.0

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("stunned")
	casted_owner.substate_timer.start(stun_time)


func _physics_update(_delta: float) -> void:
	if casted_owner.substate_timer.is_stopped():
		look_towards_target(true)
		finished.emit("Finished")


func _exit() -> void:
	pass


func _hit(data: Dictionary):
	finished.emit("Hit", data)