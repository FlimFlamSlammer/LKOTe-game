extends EnemySubstate

@export var period: float = 0.13

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("backflip")
	casted_owner.substate_timer.start(period)
	casted_owner.substate_timer.timeout.connect(_finish)


func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish() -> void:
	finished.emit("Backflipping")