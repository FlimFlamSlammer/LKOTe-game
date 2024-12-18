extends PlayerState

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("jump"):
		casted_owner.input_buffer = casted_owner.BufferableStates.JUMPING
	elif event.is_action_pressed("basic_attack"):
		casted_owner.input_buffer = casted_owner.BufferableStates.ATTACKING


func _update(delta: float) -> void:
	if casted_owner.is_on_floor():
		if absf(casted_owner.velocity.x) >= casted_owner.run_speed_treshold:
			finished.emit(States.RUNNING)
		else:
			finished.emit(States.IDLE)
	else:
		if casted_owner.time_since_attack > casted_owner.combo_length[casted_owner.combo_counter]:
			finished.emit(States.FALLING)

	casted_owner.velocity.y += casted_owner.gravity * delta

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis else casted_owner.direction
	casted_owner.velocity.x = input_axis * casted_owner.desperation

	casted_owner.move_and_slide()


func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	if (
		_previous_state_path.get_name(0) == States.JUMPING
		and casted_owner.velocity.y < casted_owner.min_jump_velocity
	): casted_owner.velocity.y = casted_owner.min_jump_velocity
	
	casted_owner.time_since_attack = 0.0
	casted_owner.anim_player.play("slash1")


func _exit() -> void:
	pass
