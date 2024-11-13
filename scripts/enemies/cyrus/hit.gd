extends EnemyHitState


func _finish() -> void:
	finished.emit("Backflipping")