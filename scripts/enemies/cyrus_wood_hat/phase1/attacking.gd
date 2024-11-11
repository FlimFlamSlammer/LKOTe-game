extends EnemySubstate

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("attack1")
	casted_owner.substate_timer.start(casted_owner.anim_player.get_animation("attack1").length)
	casted_owner.substate_timer.connect("timeout", _on_substate_timer_stopped)


func _physics_update(_delta: float) -> void:
	pass


func _exit() -> void:
	pass


func _hit(_data: Dictionary) -> void:
	pass


func _on_substate_timer_stopped():
	finished.emit("Attacking")
