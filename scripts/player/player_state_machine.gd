class_name PlayerStateMachine
extends StateMachine

@onready var casted_owner: Player = owner

func _hit(data: Dictionary) -> void:
	_set_state(PlayerState.States.HIT, data)
