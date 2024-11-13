class_name WorldScene
extends Node2D

static var player_path: NodePath = "/root/World/Level/Player"

@onready var _hitstop_timer: Timer = $HitstopTimer

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Hitstoppers"):
		node.connect("hitstop", _hitstop)


func _set_paused(paused: bool) -> void:
	$Level.process_mode = Node.PROCESS_MODE_DISABLED if paused else Node.PROCESS_MODE_INHERIT


func _hitstop(time: float) -> void:
	_set_paused(true)
	_hitstop_timer.start(time)
