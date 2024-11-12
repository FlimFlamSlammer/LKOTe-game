class_name EnemySubstate
extends EnemyCore

signal finished(next_state_path: NodePath, data: Dictionary)

@onready var machine = get_parent()

## Called when the [EnemySubState] is entered.
func _enter(previous_state_path: NodePath, data: Dictionary = {}) -> void:
	pass


## Called every frame if the current state is this [EnemySubState].
func _update(delta: float) -> void:
	pass


## Called every physics tick if the current state is this [EnemySubState].
func _physics_update(delta: float) -> void:
	pass


## Called when the [EnemySubState] is exited.
func _exit() -> void:
	pass


## Called when the [Enemy] is hit by an attack.
func _hit(data: Dictionary) -> void:
	finished.emit("Hit", data)
