extends PlayerState

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("jump"):
		finished.emit(States.JUMPING)
	elif event.is_action_pressed("basic_attack"):
		finished.emit(States.ATTACKING)


func physics_update(_delta: float) -> void:
	if casted_owner.is_on_floor():
		if absf(casted_owner.velocity.x) < casted_owner.RUN_SPEED_TRESHOLD:
			finished.emit(States.IDLE)
	else:
		finished.emit(States.FALLING)

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis else casted_owner.direction
	casted_owner.velocity.x = input_axis * casted_owner.SPEED

	casted_owner.move_and_slide()


func enter(previous_state_path: String, _data: Dictionary = {}) -> void:
	if previous_state_path in [States.FALLING, States.AIRATTACKING]:
		Camera.trauma += 0.12

	if casted_owner.input_buffer == casted_owner.BufferableStates.ATTACKING:
		finished.emit(States.ATTACKING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return
	if casted_owner.input_buffer == casted_owner.BufferableStates.JUMPING:
		finished.emit(States.JUMPING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return

	casted_owner.anim_player.play("run")


func exit() -> void:
	pass
