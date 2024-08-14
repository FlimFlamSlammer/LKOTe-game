extends CastleGuardSubStateMachine

var time_since_chase: float
var attack_counter: int
var max_attacks: int

func physics_update(delta: float) -> void:
	if state in [SubStates.RUNNING, SubStates.FALLING, SubStates.JUMPING]:
		time_since_chase += delta
		if time_since_chase > casted_owner.MAX_CHASE_TIME:
			set_state(States.DEFENDING)
	state.physics_update(delta)


func hit(data: Dictionary) -> void:
	finished.emit(States.HIT, data)


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	max_attacks = casted_owner.MIN_ATTACKS + randi() % (owner.MAX_ATTACKS - owner.MIN_ATTACKS + 1)
	attack_counter = 0
	time_since_chase = 0.0
	
	state = initial_state
	state.enter("")
