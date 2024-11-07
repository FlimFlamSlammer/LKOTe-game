class_name EnemySubstate
extends EnemyCore

signal finished(next_state_path: NodePath, data: Dictionary)

@onready var machine = get_parent()

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	pass


func _physics_update(_delta: float) -> void:
	pass


func _exit() -> void:
	pass


func _hit(_data: Dictionary) -> void:
	pass
