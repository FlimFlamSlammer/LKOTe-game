class_name EnemyState
extends EnemySubstate

@export var initial_state: EnemySubstate

@onready var substate: EnemySubstate = initial_state

func _ready() -> void:
	for child_state: EnemySubstate in get_children():
		child_state.finished.connect(_set_state)


func _enter(_previous_state_path: NodePath, data: Dictionary = {}) -> void:
	substate = initial_state
	substate._enter(data.previous_substate if data.has("previous_substate") else "")


func _update(delta: float) -> void:
	substate._update(delta)


func _physics_update(delta: float) -> void:
	substate._physics_update(delta)


func _exit() -> void:
	pass


func _hit(data: Dictionary) -> void:
	substate._hit(data)


## Changes the state to the [EnemySubstate] referred in [code]param next_state_path[/code].
## Set [code]param next_state_path[/code] to [code]"Finished"[/code] to call the [code]_finished[/code] function.
func _set_state(
		next_state_path: NodePath, # path relative to this state
		data: Dictionary = {},
) -> void:
	substate._exit()
	var previous_state_path: NodePath = machine.get_path_to(substate)
	if next_state_path == ("Finished" as NodePath):
		_finish({
			previous_substate = previous_state_path, ## The state that called [code]_set_state("Finished", ...)[/code].
		})
	else:
		substate = get_node_or_null(next_state_path)

		if !substate:
			printerr("Substate " + (next_state_path as String) + " does not exist!")

		substate._enter(previous_state_path, data)


## Called when [code]_set_state[/code] is called with the [code]"Finished"[/code] param.
## [code]param data[/code] contains the path to the [EnemySubstate] that called [code]_set_state("Finished", ...)[/code]
func _finish(_data: Dictionary) -> void:
	pass
