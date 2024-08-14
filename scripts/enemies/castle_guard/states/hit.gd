extends CastleGuardSubStateMachine

var time_since_chase: float
var attack_counter: int
var max_attacks: int

func physics_update(delta: float) -> void:
	state.physics_update(delta)


func hit(data: Dictionary) -> void:
	enter(States.HIT, data)


func enter(_previous_state_path: String, data: Dictionary = {}) -> void:
	casted_owner.health -= data.damage
	casted_owner.step(-data.knockback)
	if casted_owner.health <= 0:
		state = get_node(SubStates.DYING)
	else:
		state = get_node(SubStates.HIT)

	state.enter("", data)
