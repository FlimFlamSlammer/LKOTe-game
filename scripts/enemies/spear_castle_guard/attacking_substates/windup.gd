extends EnemySubstate

@export var windup_time: float = 1.0

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("windup")

	casted_owner.substate_timer.start(windup_time)
	casted_owner.substate_timer.connect("timeout", finished.emit.bind("Charging"))


func _physics_update(_delta: float) -> void:
	pass

func _exit() -> void:
	pass


func _hit(data: Dictionary):
	finished.emit("Hit", data)
