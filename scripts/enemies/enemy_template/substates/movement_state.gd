class_name EnemyMovementState
extends EnemySubstate

@export var speed_multiplier: float = 1
@export var move_towards_target: bool

func _update(delta: float) -> void:
	if move_towards_target:
		look_towards_target(true)
	move_forward(speed_multiplier)
	apply_gravity(delta)

	casted_owner.move_and_slide()
