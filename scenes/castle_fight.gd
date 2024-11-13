extends Node2D

@export var boss: PackedScene

var enemies: int = 2
var wave: int = 1


func _process(delta: float) -> void:
	enemies = get_tree().get_node_count_in_group("Enemies")
	if enemies == 0 and wave == 1:
		get_tree().call_group("Walls", "queue_free")
		wave += 1
		var new_boss: Enemy = boss.instantiate()
		new_boss.position.x = 100.0
		add_child(new_boss)
