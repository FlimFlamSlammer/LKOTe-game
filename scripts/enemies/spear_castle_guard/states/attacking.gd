extends EnemyState

func _finish(data: Dictionary) -> void:
	finished.emit("Defending", data)