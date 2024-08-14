class_name StateMachine
extends Node

@export var initial_state: State = null

@onready var state: State = initial_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child_state: State in get_children():
		child_state.finished.connect(set_state)

	await owner.ready
	state.enter("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	state.physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func set_state(next_state_path: String, data: Dictionary = {}, resume: bool = false) -> void:
	var prev_state_path: String = state.name
	state.exit()
	state = get_node(next_state_path)
	if !resume:
		state.enter(prev_state_path, data)
