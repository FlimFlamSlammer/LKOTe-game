class_name CastleGuardState
extends State

const SubStates: Dictionary = {
	FINISHED = "Finished",
	RUNNING = "Running",
	ATTACKING = "Attacking",
	JUMPING = "Jumping",
	AIRATTACKING = "AirAttacking",
	FALLING = "Falling",
	DODGING = "Dodging",
	HIT = "Hit",
	DYING = "Dying",
}

@onready var casted_owner: CastleGuard = owner

@onready var parent := get_parent()
