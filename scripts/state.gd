class_name State
extends Node

signal finished(next_state_path: NodePath, data: Dictionary)

func _handle_input(_event: InputEvent) -> void:
	pass


func _physics_update(_delta: float) -> void:
	pass


func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	pass


func _exit() -> void:
	pass
