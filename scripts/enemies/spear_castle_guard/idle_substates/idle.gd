extends EnemySubstate

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("idle")


func _update(_delta: float) -> void:
	if not casted_owner.is_on_floor():
		finished.emit("Falling")

	
func _exit() -> void:
	pass