class_name PlayerState extends State

const States: Dictionary = {
	IDLE = "Idle",
	RUNNING = "Running",
	ATTACKING = "Attacking",
	AIRATTACKING = "AirAttacking",
	RECOVERING = "Recovering",
	DODGING = "Dodging",
	JUMPING = "Jumping",
	FALLING = "Falling",
}

@onready var casted_owner: Player = owner
