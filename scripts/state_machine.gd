class_name StateMachine
extends Node

@export var initial_state: State = null

@onready var state: State = initial_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child_state: State in get_children():
		child_state.finished.connect(_set_state)

	await owner.ready
	state._enter("")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state._update(delta)


func _physics_process(delta: float) -> void:
	state._physics_update(delta)


func _unhandled_input(event: InputEvent) -> void:
	state._handle_input(event)


func _hit(data: Dictionary) -> void:
	state._hit(data)


func _set_state(next_state_path: NodePath, data: Dictionary = {}, resume: bool = false) -> void:
	var previous_state_path: NodePath = get_path_to(state)
	state._exit()
	state = get_node_or_null(str(next_state_path.get_name(0)))

	if !state:
		printerr("State " + (next_state_path as String) + " does not exist!")

	if !resume:
		state._enter(previous_state_path, data)
