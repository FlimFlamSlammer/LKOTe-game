extends Node2D

@export var boss: PackedScene

var enemies: int = 2
var wave: int = 1


func _update() -> void:
	enemies = get_tree().get_node_count_in_group("Enemies")
	if enemies == 0 or wave == 1:
		wave += 1
		var new_boss: Enemy = boss.instantiate()
		new_boss.position.x = 100.0
		add_child(new_boss)
