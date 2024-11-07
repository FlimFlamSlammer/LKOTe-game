extends PlayerState

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("basic_attack"):
		finished.emit(States.AIRATTACKING)
	elif event.is_action_pressed("jump"):
		casted_owner.input_buffer = casted_owner.BufferableStates.JUMPING

	if casted_owner.velocity.y < casted_owner.min_jump_velocity and event.is_action_released("jump"):
		casted_owner.velocity.y = casted_owner.min_jump_velocity


func _physics_update(delta: float) -> void:
	if casted_owner.velocity.y > 0:
		finished.emit(States.FALLING)

	casted_owner.velocity.y += casted_owner.gravity * delta * 0.7

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis != 0 else casted_owner.direction
	casted_owner.velocity.x = input_axis * casted_owner.speed

	casted_owner.move_and_slide()


func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	if casted_owner.input_buffer == casted_owner.BufferableStates.ATTACKING:
		finished.emit(States.AIRATTACKING)
		casted_owner.input_buffer = casted_owner.BufferableStates.NONE
		return

	# make jump height low if jump button is not currently pressed
	casted_owner.velocity.y = (
			casted_owner.jump_velocity if Input.is_action_pressed("jump")
			else casted_owner.min_jump_velocity)

	casted_owner.anim_player.play("jump")


func _exit() -> void:
	pass
