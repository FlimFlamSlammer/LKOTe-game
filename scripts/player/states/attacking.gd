extends PlayerState

@export var step_period: float = 0.05

var _step_distance: float
var _step_velocity: float

func _handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("dodge"):
		finished.emit(States.DODGING)
	elif event.is_action_pressed("jump"):
		finished.emit(States.JUMPING)
	elif event.is_action_pressed("basic_attack"):
		casted_owner.input_buffer = casted_owner.BufferableStates.ATTACKING



func _update(delta: float) -> void:
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

	if _step_distance > 0:
		_progress_step(delta)

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

	casted_owner.velocity.x = 0
	_step_distance = 0
	_step_velocity = 0

	casted_owner.stepped_to_target.connect(_set_step)


func _set_step(distance: float) -> void:
	_step_distance += distance
	_step_velocity = _step_distance / step_period * casted_owner.direction
	casted_owner.velocity.x = _step_velocity


func _progress_step(delta: float) -> void:
	_step_distance -= absf(_step_velocity * delta)
	if _step_distance <= 0:
		_step_distance = 0
		_step_velocity = 0
		casted_owner.velocity.x = 0


func _exit() -> void:
	casted_owner.stepped_to_target.disconnect(_set_step)
