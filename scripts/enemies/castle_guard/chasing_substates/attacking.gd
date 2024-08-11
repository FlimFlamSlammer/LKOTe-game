extends CastleGuardState

func physics_update(delta: float) -> void:
	if casted_owner.time_since_attack > casted_owner.ATTACK_LENGTH[casted_owner.combo_counter]:
		var x_distance = casted_owner.target.position.x - casted_owner.position.x
		var y_distance = casted_owner.target.position.y - casted_owner.position.y

		if parent.attack_counter > parent.max_attacks:
			finished.emit(SubStates.FINISHED)
		elif absf(x_distance) > casted_owner.ATTACK_RANGE:
			finished.emit(SubStates.RUNNING)
		elif y_distance < casted_owner.JUMP_Y_DISTANCE:
			finished.emit(SubStates.JUMPING)
		else:
			finished.emit(SubStates.ATTACKING)
	
	if casted_owner.step_distance:
		casted_owner.velocity.x = casted_owner.step_distance * casted_owner.direction / delta

	casted_owner.move_and_slide()

	casted_owner.velocity.x = 0


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	parent.attack_counter += 1
	if _previous_state_path == SubStates.ATTACKING:
		casted_owner.combo_counter += 1
	casted_owner.anim_player.play("attack" + str(casted_owner.combo_counter))


func exit() -> void:
	pass
