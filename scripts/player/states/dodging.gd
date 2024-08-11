extends PlayerState

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		casted_owner.input_buffer = casted_owner.BufferableStates.JUMPING
	elif event.is_action_pressed("basic_attack"):
		casted_owner.input_buffer = casted_owner.BufferableStates.ATTACKING


func physics_update(_delta: float) -> void:
	if casted_owner.time_since_dodge > casted_owner.DODGE_LENGTH:
		if casted_owner.is_on_floor():
			finished.emit(States.RUNNING)
		else:
			finished.emit(States.FALLING)

	casted_owner.move_and_slide()


func enter(previous_state_path: String, _data: Dictionary = {}) -> void:
	if casted_owner.time_since_dodge <= casted_owner.DODGE_COOLDOWN:
		finished.emit(previous_state_path, {}, true)
		return
	casted_owner.time_since_dodge = 0.0

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis else casted_owner.direction

	casted_owner.velocity.x = casted_owner.DODGE_SPEED * casted_owner.direction
	casted_owner.velocity.y = 0

	Camera.trauma += 0.1
	casted_owner.instantiate_temp_fx(TempFX.Effects.DODGE)
	casted_owner.anim_player.play("dodge")


func exit() -> void:
	pass
