class_name EnemyStateMachine
extends EnemyCore

@export var initial_state: EnemySubstate = null

@onready var state: EnemySubstate = initial_state

func _ready() -> void:
	for child_state: EnemySubstate in get_children():
		child_state.finished.connect(_set_state)

	await owner.ready
	state._enter("")


func _process(delta: float) -> void:
	state._update(delta)


func _physics_process(delta: float) -> void:
	state._physics_update(delta)


func _set_state(next_state_path: NodePath, data: Dictionary = {}, resume: bool = false) -> void:
	var previous_state_path: NodePath = get_path_to(state)
	state._exit()
	state = get_node_or_null(str(next_state_path.get_name(0)))

	if !state:
		printerr("State " + (next_state_path as String) + " does not exist!")

	if !resume:
		if next_state_path.get_name_count() == 2:
			data.next_substate_path = next_state_path.get_name(1)
		state._enter(previous_state_path, data)


func _hit(data: Dictionary) -> void:
	state._hit(data)
