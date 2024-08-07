class_name DodgeEffect
extends Node2D

var direction: int

@onready var _ghost_effect: GPUParticles2D = get_node("DashGhost")

func _ready():
	var texture: Resource = (
			preload("res://assets/3knight-dash-mirrored.png") if direction < 0
			else preload("res://assets/3knight-dash.png")
	)
	_ghost_effect.texture = texture
	_ghost_effect.emitting = true

func _on_free_timer_timeout():
	queue_free()
