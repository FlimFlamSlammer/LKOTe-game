extends CastleGuardState

func physics_update(_delta: float) -> void:
	var x_distance: float = casted_owner.target.position.x - casted_owner.position.x

	casted_owner.velocity.x = casted_owner.direction * casted_owner.SPEED

	casted_owner.move_and_slide()

	if casted_owner.is_on_floor():
		if absf(x_distance) < casted_owner.JUMP_RANGE:
			var y_distance: float = casted_owner.target.position.y - casted_owner.position.y
			if y_distance < casted_owner.JUMP_Y_DISTANCE:
				finished.emit(SubStates.JUMPING)

			elif absf(x_distance) < casted_owner.DISTANCE_TO_DODGE:
				finished.emit(SubStates.DODGING)
	else:
		finished.emit(SubStates.FALLING)


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("run")


func exit() -> void:
	pass
