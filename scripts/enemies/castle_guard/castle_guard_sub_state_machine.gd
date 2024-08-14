class_name CastleGuardSubStateMachine
extends CastleGuardState

const States: Dictionary = {
	CHASING = "Chasing",
	OBSERVING = "Observing",
	HIT = "Hit",
	DEFENDING = "Defending",
	DEAD = "Dead"
}

@export var initial_state: State

var state: State

func _ready() -> void:
	for child_state: State in get_children():
		child_state.finished.connect(set_state)


func physics_update(delta: float) -> void:
	state.physics_update(delta)


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	state = initial_state
	state.enter("")


func exit() -> void:
	pass

func hit(data: Dictionary) -> void:
	state.hit(data)


func set_state(
		next_state_path: String,
		data: Dictionary = {},
		resume: bool = false
) -> void:
	var prev_state_path: String = state.name
	state.exit()
	if next_state_path == "Finished":
		finished.emit(data.next_state_path)
		return
	state = get_node(next_state_path)
	if !resume:
		state.enter(prev_state_path, data)
