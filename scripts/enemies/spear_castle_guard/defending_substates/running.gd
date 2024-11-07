extends EnemyMovementState

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("run")


func _physics_update(delta: float) -> void:
	super(delta)
	
	if not casted_owner.is_on_floor():
		finished.emit("Falling")


func _exit() -> void:
	pass