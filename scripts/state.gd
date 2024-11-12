class_name State
extends Node

signal finished(next_state_path: NodePath, data: Dictionary)

func _handle_input(_vent: InputEvent) -> void:
	pass


func _update(delta: float) -> void:
	pass


func _physics_update(delta: float) -> void:
	pass


func _enter(previous_state_path: NodePath, data: Dictionary = {}) -> void:
	pass


func _exit() -> void:
	pass
