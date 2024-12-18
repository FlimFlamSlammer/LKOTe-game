extends PlayerState

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("basic_attack"):
		finished.emit(States.AIRATTACKING)
	elif event.is_action_pressed("jump"):
		casted_owner.input_buffer = casted_owner.BufferableStates.JUMPING


func _update(delta: float) -> void:
	casted_owner.velocity.y += casted_owner.gravity * delta

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis else casted_owner.direction
	casted_owner.velocity.x = input_axis * casted_owner.desperation

	casted_owner.move_and_slide()

	if casted_owner.is_on_floor():
		if absf(casted_owner.velocity.x) >= casted_owner.run_speed_treshold:
			finished.emit(States.RUNNING)
		else:
			finished.emit(States.IDLE)
	else:
		if casted_owner.velocity.y > 0:
			casted_owner.anim_player.play("fall")
		else:
			casted_owner.anim_player.play("jump")


func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	if casted_owner.input_buffer == casted_owner.BufferableStates.ATTACKING:
		finished.emit(States.AIRATTACKING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return

	if casted_owner.velocity.y > 0:
		casted_owner.anim_player.play("fall")
	else:
		casted_owner.anim_player.play("jump")


func _exit() -> void:
	pass
