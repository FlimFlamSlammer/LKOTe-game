extends PlayerState

var prev_collision_layer: int

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		casted_owner.input_buffer = casted_owner.BufferableStates.JUMPING
	elif event.is_action_pressed("basic_attack"):
		casted_owner.input_buffer = casted_owner.BufferableStates.ATTACKING


func _physics_update(_delta: float) -> void:
	if casted_owner.time_since_dodge > casted_owner.dodge_length:
		if casted_owner.is_on_floor():
			finished.emit(States.RUNNING)
		else:
			finished.emit(States.FALLING)

	casted_owner.move_and_slide()


func _enter(previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	if casted_owner.time_since_dodge <= casted_owner.dodge_cooldown:
		finished.emit(previous_state_path, {}, true)
		return
	casted_owner.time_since_dodge = 0.0

	var input_axis: float = Input.get_axis("move_left", "move_right")
	casted_owner.direction = sign(input_axis) if input_axis else casted_owner.direction

	casted_owner.velocity.x = casted_owner.speed * casted_owner.dodge_speed * casted_owner.direction
	casted_owner.velocity.y = 0.0

	prev_collision_layer = casted_owner.collision_layer
	casted_owner.collision_layer = 0

	casted_owner.instantiate_temp_fx(TempFX.Effects.DODGE, {
		"resource": "res://assets/3knight-dash.png"
	})
	casted_owner.anim_player.play("dodge")


func _exit() -> void:
	casted_owner.collision_layer = prev_collision_layer
