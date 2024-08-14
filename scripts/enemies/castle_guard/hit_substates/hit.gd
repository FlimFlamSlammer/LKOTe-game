extends CastleGuardState

func physics_update(delta: float) -> void:
	casted_owner.velocity.y += casted_owner.gravity * delta

	if casted_owner.step_distance:
		casted_owner.velocity.x = casted_owner.step_distance / delta
		casted_owner.step_distance = 0

	casted_owner.move_and_slide()

	casted_owner.velocity.x = 0

	if casted_owner.time_until_recover <= 0.0:
		finished.emit(SubStates.FINISHED, {next_state_path = "Defending"})


func enter(_previous_state_path: String, data: Dictionary = {}) -> void:
	casted_owner.direction = -data.direction
	casted_owner.time_until_recover = data.stun_time / casted_owner.STUN_RESISTANCE

	casted_owner.anim_player.play("hit")


func exit() -> void:
	pass
