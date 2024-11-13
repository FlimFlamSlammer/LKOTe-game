extends EnemyState

func _enter(previous_state_path: NodePath, data: Dictionary = {}) -> void:
	super(previous_state_path, data)


func _update(delta: float) -> void:
	super(delta)


func _exit() -> void:
	pass


func _hit(data: Dictionary) -> void:
	substate._hit(data)


func _finish(_data: Dictionary) -> void:
	pass
