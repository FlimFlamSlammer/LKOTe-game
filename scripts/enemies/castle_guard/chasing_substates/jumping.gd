extends CastleGuardState


func physics_update(delta: float) -> void:
	casted_owner.velocity.y += casted_owner.gravity * delta * 0.7

	var x_distance = casted_owner.target.position.x - casted_owner.position.x
	casted_owner.direction = sign(x_distance)
	if absf(x_distance) > casted_owner.ATTACK_RANGE:
		casted_owner.velocity.x = casted_owner.direction * casted_owner.SPEED


	casted_owner.move_and_slide()
	
	if casted_owner.velocity.y > 0:
		finished.emit(SubStates.FALLING)
	
	var predicted_y = (
		casted_owner.target.position.y
		+ casted_owner.target.velocity.y * 0.1
		- casted_owner.velocity.y * 0.1
	)
	var y_distance = predicted_y - casted_owner.position.y

	if y_distance > -casted_owner.VERTICAL_ATTACK_RANGE:
		if y_distance < casted_owner.VERTICAL_ATTACK_RANGE:
			finished.emit(SubStates.AIRATTACKING)
		elif casted_owner.velocity.y < casted_owner.MIN_JUMP_VELOCITY:
			casted_owner.velocity.y = casted_owner.MIN_JUMP_VELOCITY


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.velocity.y = casted_owner.JUMP_VELOCITY

	casted_owner.anim_player.play("jump")


func exit() -> void:
	pass
