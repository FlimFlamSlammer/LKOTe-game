extends EnemyMovementState

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("fall")


func _physics_update(delta: float) -> void:
	super(delta)

	if not casted_owner.is_on_floor():
		finished.emit("Running")


func _exit() -> void:
	pass