extends CastleGuardState


func physics_update(delta: float) -> void:
	casted_owner.velocity.y += casted_owner.gravity * delta * 0.7
	casted_owner.velocity.x = casted_owner.direction * casted_owner.SPEED

	casted_owner.move_and_slide()

	if casted_owner.is_on_floor():
		finished.emit(SubStates.RUNNING)
	elif casted_owner.position.distance_squared_to(casted_owner.target.position) < casted_owner.DISTANCE_TO_DODGE ** 2:
		finished.emit(SubStates.DODGING)
	elif casted_owner.velocity.y > 0:
		finished.emit(SubStates.FALLING)


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.velocity.y = casted_owner.JUMP_VELOCITY

	casted_owner.anim_player.play("jump")


func exit() -> void:
	pass
