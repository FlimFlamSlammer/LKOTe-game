extends CastleGuardSubStateMachine

func physics_update(delta: float) -> void:
	var x_distance: float = casted_owner.target.position.x - casted_owner.position.x
	if absf(x_distance) < casted_owner.ATTACK_RANGE:
		var chance_to_attack: float = casted_owner.health
		if randf() * casted_owner.max_health < chance_to_attack:
			finished.emit(States.CHASING)
		else:
			finished.emit(States.DEFENDING)

	state.physics_update(delta)

func hit(data: Dictionary) -> void:
	finished.emit(States.DEFENDING, data)

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	state = initial_state
	state.enter("")
