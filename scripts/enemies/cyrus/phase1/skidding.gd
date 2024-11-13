extends EnemySubstate

@export var friction: float = 0.9999
## The time it takes to stop skidding.
@export var skid_period: float = 0.5

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.substate_timer.start(skid_period)
	casted_owner.substate_timer.timeout.connect(_finish)


func _update(delta: float) -> void:
	casted_owner.velocity.x *= pow(1 - friction, delta)
	casted_owner.move_and_slide()

	
func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish() -> void:
	finished.emit("Attacking")
