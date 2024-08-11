extends CastleGuardState


func physics_update(delta: float) -> void:
	if casted_owner.is_on_floor():
		finished.emit(SubStates.RUNNING)
	else:
		var predicted_y = (
			casted_owner.target.position.y
			+ casted_owner.target.velocity.y * 0.1
			- casted_owner.velocity.y * 0.1
		)
		var y_distance = predicted_y - casted_owner.position.y

		if (
				y_distance > -casted_owner.VERTICAL_ATTACK_RANGE
				and y_distance < casted_owner.VERTICAL_ATTACK_RANGE
		):
			finished.emit(SubStates.AIRATTACKING)

	if casted_owner.velocity.y > 0:
		casted_owner.anim_player.play("fall")
	else:
		casted_owner.anim_player.play("jump")

	casted_owner.velocity.y += casted_owner.gravity * delta

	var x_distance = casted_owner.target.position.x - casted_owner.position.x
	casted_owner.direction = sign(x_distance)
	if absf(x_distance) > casted_owner.ATTACK_RANGE:
		casted_owner.velocity.x = casted_owner.direction * casted_owner.SPEED

	casted_owner.move_and_slide()


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	pass


func exit() -> void:
	pass
