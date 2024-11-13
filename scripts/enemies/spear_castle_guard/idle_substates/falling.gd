extends EnemySubstate

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("fall")


func _update(delta: float) -> void:
	if casted_owner.is_on_floor():
		finished.emit("Idle")

	apply_gravity(delta)
	casted_owner.move_and_slide()


func _exit() -> void:
	pass