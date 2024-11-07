class_name EnemyState
extends EnemySubstate

@export var initial_state: EnemySubstate

@onready var substate: EnemySubstate = initial_state

func _ready() -> void:
	for child_state: EnemySubstate in get_children():
		child_state.finished.connect(_set_state)


func _physics_update(delta: float) -> void:
	substate._physics_update(delta)


func _enter(_previous_state_path: NodePath, data: Dictionary = {}) -> void:
	substate = initial_state
	substate._enter(data.previous_substate if data.has("previous_substate") else "")


func _exit() -> void:
	pass


func _hit(data: Dictionary) -> void:
	substate._hit(data)


func _set_state(
		next_substate_path: NodePath, # path relative to this state
		data: Dictionary = {},
) -> void:
	substate._exit()
	var previous_state_path: NodePath = machine.get_path_to(substate)
	if next_substate_path == ("Finished" as NodePath):
		_finish({
			previous_substate = previous_state_path,
		})
	else:
		substate = get_node_or_null(next_substate_path)

		if !substate:
			printerr("Substate " + (next_substate_path as String) + " does not exist!")

		substate._enter(previous_state_path, data)


func _finish(_data: Dictionary) -> void:
	pass
