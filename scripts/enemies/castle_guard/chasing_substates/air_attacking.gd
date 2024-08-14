extends CastleGuardState


func physics_update(delta: float) -> void:
	var x_distance = casted_owner.target.position.x - casted_owner.position.x
	casted_owner.direction = sign(x_distance)
	if absf(x_distance) > casted_owner.ATTACK_RANGE:
		casted_owner.velocity.x = casted_owner.direction * casted_owner.SPEED

	casted_owner.move_and_slide()

	if casted_owner.is_on_floor():
		finished.emit(SubStates.RUNNING)
	else:
		if casted_owner.time_since_attack > casted_owner.COMBO_LENGTH[casted_owner.combo_counter]:
			finished.emit(SubStates.FALLING)

	casted_owner.velocity.y += casted_owner.gravity * delta


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.time_since_attack = 0.0
	casted_owner.anim_player.play("attack1")


func exit() -> void:
	pass
