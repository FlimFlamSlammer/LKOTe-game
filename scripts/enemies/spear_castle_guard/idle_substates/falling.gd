extends EnemySubstate

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("fall")


func _physics_update(_delta: float) -> void:
	if casted_owner.is_on_floor():
		finished.emit("Idle")

	apply_gravity()
	casted_owner.move_and_slide()

	
func _exit() -> void:
	pass