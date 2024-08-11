extends CastleGuardSubStateMachine

var time_since_defending: float
var direction_from_player: int

func physics_update(delta: float):
	time_since_defending += delta
	if time_since_defending > casted_owner.MAX_DEFEND_TIME:
		finished.emit(States.CHASING)

	if casted_owner.wall_ray_cast.is_colliding():
		casted_owner.direction = -casted_owner.direction
		

func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.direction = sign(casted_owner.target.position.x - casted_owner.position.x)
	time_since_defending = 0.0

	state = initial_state
	state.enter("")