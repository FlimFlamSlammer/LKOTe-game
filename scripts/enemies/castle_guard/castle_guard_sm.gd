class_name CastleGuardStateMachine
extends StateMachine

func _unhandled_input(_event: InputEvent) -> void:
	pass


func _physics_process(delta: float) -> void:
	state.physics_update(delta)
	owner.fatboytext.text = state.state.name

func hit(data: Dictionary) -> void:
	state.hit(data)
