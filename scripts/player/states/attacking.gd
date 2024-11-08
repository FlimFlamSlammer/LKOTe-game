extends PlayerState

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("jump"):
		finished.emit(States.JUMPING)
	elif event.is_action_pressed("basic_attack"):
		casted_owner.input_buffer = casted_owner.BufferableStates.ATTACKING



func _physics_update(delta: float) -> void:
	casted_owner.velocity.x = 0

	if casted_owner.is_on_floor():
		if casted_owner.time_since_attack > casted_owner.combo_length[casted_owner.combo_counter]:
			finished.emit(States.RECOVERING)
	else:
		finished.emit(States.FALLING)

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = casted_owner.direction + (
			((casted_owner.direction * (input_axis == 0 as int) + sign(input_axis))
			- casted_owner.direction)
			* (casted_owner.can_flip as int))

	if casted_owner.step_distance > 0:
		casted_owner.velocity.x = casted_owner.step_distance * casted_owner.direction / delta
		casted_owner.step_distance = 0
	casted_owner.move_and_slide()


func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	if casted_owner.input_buffer == casted_owner.BufferableStates.JUMPING:
		finished.emit(States.JUMPING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return

	if casted_owner.time_since_recover < casted_owner.combo_reset_delay:
		casted_owner.combo_counter += 1
		casted_owner.combo_counter = casted_owner.combo_counter % casted_owner.combo_length.size()
	else:
		casted_owner.combo_counter = 0
	casted_owner.time_since_attack = 0.0
	casted_owner.can_flip = true

	casted_owner.anim_player.play("slash" + str(casted_owner.combo_counter + 1))


func _exit() -> void:
	pass
