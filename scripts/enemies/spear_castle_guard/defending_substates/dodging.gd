extends EnemyDodgeState

func _enter(previous_state_path: NodePath, data: Dictionary = {}) -> void:
	super(previous_state_path, data)


func _physics_update(delta: float) -> void:
	super(delta)


func _finish() -> void:
	finished.emit("Running")


func _exit() -> void:
	super()