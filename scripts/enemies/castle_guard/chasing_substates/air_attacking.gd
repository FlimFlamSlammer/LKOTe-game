extends CastleGuardState


func physics_update(delta: float) -> void:
	if casted_owner.is_on_floor():
		if absf(casted_owner.velocity.x) >= casted_owner.RUN_SPEED_TRESHOLD:
			finished.emit(SubStates.RUNNING)
	else:
		if casted_owner.time_since_attack > casted_owner.COMBO_LENGTH[casted_owner.combo_counter]:
			finished.emit(SubStates.FALLING)

	casted_owner.velocity.y += casted_owner.gravity * delta

	# Horizontal movement
	var x_distance = casted_owner.target.position.x - casted_owner.position.x
	casted_owner.direction = sign(x_distance)
	if absf(x_distance) > casted_owner.ATTACK_RANGE:
		casted_owner.velocity.x = casted_owner.direction * casted_owner.SPEED

	casted_owner.move_and_slide()


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.time_since_attack = 0.0
	casted_owner.anim_player.play("air_attack")


func exit() -> void:
	pass
