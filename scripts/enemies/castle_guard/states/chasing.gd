extends CastleGuardSubStateMachine

var time_since_chase: float
var attack_counter: int
var max_attacks: int

func physics_update(delta: float):
	if state in [SubStates.RUNNING, SubStates.FALLING, SubStates.JUMPING]:
		time_since_chase += delta
		if time_since_chase > casted_owner.MAX_CHASE_TIME:
			set_state(SubStates.FINISHED, {next_state_path = States.OBSERVING})


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	max_attacks = casted_owner.MIN_ATTACKS + randi() % (owner.MAX_ATTACKS - owner.MIN_ATTACKS + 1)
	attack_counter = 0
	time_since_chase = 0.0
	state = initial_state
	state.enter("")
