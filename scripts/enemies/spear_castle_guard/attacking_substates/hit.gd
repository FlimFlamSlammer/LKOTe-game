extends EnemyHitState

func _finished() -> void:
	finished.emit("Finished")


func _hit(data: Dictionary) -> void:
	finished.emit("Hit", data)