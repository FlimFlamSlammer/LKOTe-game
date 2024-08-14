extends CastleGuardState

func physics_update(_delta: float) -> void:
	casted_owner.move_and_slide()
	if casted_owner.time_since_dodge > casted_owner.DODGE_LENGTH:
		if casted_owner.is_on_floor():
			finished.emit(SubStates.RUNNING)
		else:
			finished.emit(SubStates.FALLING)


func enter(previous_state_path: String, _data: Dictionary = {}) -> void:
	if casted_owner.time_since_dodge <= casted_owner.DODGE_COOLDOWN:
		finished.emit(previous_state_path, {}, true)
		return
	casted_owner.time_since_dodge = 0.0

	casted_owner.velocity.x = casted_owner.DODGE_SPEED * casted_owner.direction
	casted_owner.velocity.y = 0.0

	casted_owner.instantiate_temp_fx(TempFX.Effects.DODGE)
	casted_owner.anim_player.play("dodge")


func exit() -> void:
	pass
