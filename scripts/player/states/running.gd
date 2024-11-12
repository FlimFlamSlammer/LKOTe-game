extends PlayerState

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("jump"):
		finished.emit(States.JUMPING)
	elif event.is_action_pressed("basic_attack"):
		finished.emit(States.ATTACKING)


func _update(_delta: float) -> void:
	if casted_owner.is_on_floor():
		if absf(casted_owner.velocity.x) < casted_owner.run_speed_treshold:
			finished.emit(States.IDLE)
	else:
		finished.emit(States.FALLING)

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis else casted_owner.direction
	casted_owner.velocity.x = input_axis * casted_owner.speed

	casted_owner.move_and_slide()


func _enter(previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	if previous_state_path in [States.FALLING, States.AIRATTACKING]:
		casted_owner.screenshake.emit(0.08)

	if casted_owner.input_buffer == casted_owner.BufferableStates.ATTACKING:
		finished.emit(States.ATTACKING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return
	if casted_owner.input_buffer == casted_owner.BufferableStates.JUMPING:
		finished.emit(States.JUMPING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return

	casted_owner.anim_player.play("run")


func _exit() -> void:
	pass
