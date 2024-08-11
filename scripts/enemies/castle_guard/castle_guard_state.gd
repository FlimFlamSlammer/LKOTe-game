class_name CastleGuardState
extends State

const SubStates: Dictionary = {
	FINISHED = "",
	RUNNING = "Running",
	ATTACKING = "Attacking",
	JUMPING = "Jumping",
	AIRATTACKING = "AirAttacking",
	FALLING = "Falling",
	DODGING = "Dodging"
}

var casted_owner: CastleGuard = owner

@onready var parent: CastleGuardSubStateMachine = get_parent()
