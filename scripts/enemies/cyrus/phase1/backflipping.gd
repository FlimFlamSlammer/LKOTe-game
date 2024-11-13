extends EnemySubstate

@export var jump_velocity: float = -250.0
@export var backflip_speed: float = 200.0

var _in_air: bool

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.velocity.y = jump_velocity
	casted_owner.velocity.x = backflip_speed * -casted_owner.direction

	_in_air = false


func _update(delta: float) -> void:
	if casted_owner.velocity.y > 0:
		apply_gravity(delta * 1.8)
	else:
		apply_gravity(delta * 1.2)
	casted_owner.move_and_slide()

	if not (_in_air or casted_owner.is_on_floor()):
		_in_air = true
	elif _in_air and casted_owner.is_on_floor():
		finished.emit("Skidding")


func _exit() -> void:
	pass
