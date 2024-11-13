extends EnemySubstate

## The time it takes for the attack to complete.
@export var attack_period: float = 0.8
@export var attack_amount_range := Vector2i(1, 4)

var _attack_amount: int

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	_attack_amount = randi_range(attack_amount_range.x, attack_amount_range.y)
	casted_owner.substate_timer.timeout.connect(_finish)
	_attack()


func _update(delta: float) -> void:
	apply_gravity(delta)
	casted_owner.move_and_slide()


func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish():
	if _attack_amount <= 0:
		finished.emit("BackflipWindup")
	else:
		_attack()


func _attack():
	look_towards_target(true)
	casted_owner.anim_player.play("attack1")
	casted_owner.substate_timer.start(attack_period)
	_attack_amount -= 1
