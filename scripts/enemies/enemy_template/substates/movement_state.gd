class_name EnemyMovementState
extends EnemySubstate

@export var speed_multiplier: float = 1
@export var move_towards_target: bool

func _physics_update(_delta: float) -> void:
	if move_towards_target:
		look_towards_target(true)
	move_forward(speed_multiplier)
	apply_gravity()

	casted_owner.move_and_slide()
