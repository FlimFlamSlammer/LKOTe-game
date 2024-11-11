extends EnemySubstate

@export var stun_time: float = 2.0

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("stunned")

	casted_owner.substate_timer.start(stun_time)
	casted_owner.substate_timer.connect("timeout", _on_substate_timer_timeout)


func _physics_update(_delta: float) -> void:
	pass
		

func _exit() -> void:
	pass


func _hit(data: Dictionary):
	finished.emit("Hit", data)


func _on_substate_timer_timeout():
	look_towards_target(true)
	finished.emit("Finished")