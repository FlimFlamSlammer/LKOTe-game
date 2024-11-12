class_name Camera
extends Camera2D

@export var smoothness: float = 0.001

@export var shake_sustain: float = 0.0001
@export var shake_smoothness: float = 0.0000001
@export var max_offset := Vector2(1200, 900)
@export var trauma_exponent: float = 2.0

@export var shift_shader_material: ShaderMaterial

var trauma: float = 0.0
var world_position: Vector2
var time: float = 0.0

var _noise
var _smoothed_trauma: float = 0.0

@onready var world_scene: WorldScene = owner
@onready var _player: Player = world_scene.get_node(WorldScene.player_path)
@onready var target: Node2D = _player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_noise = preload("res://scripts/softnoise.gd").SoftNoise.new()
	randomize()

	for node in get_tree().get_nodes_in_group("Screenshakers"):
		node.connect("screenshake", _add_trauma)


func _process(delta: float) -> void:
	world_position += (target.position - world_position) * (1 - pow(smoothness, delta))
	position = world_position

	if _smoothed_trauma or trauma:
		trauma -= trauma * (1 - pow(shake_sustain, delta))
		_smoothed_trauma += (trauma - _smoothed_trauma) * (1 - pow(shake_smoothness, delta))
		shake()

	time += delta * 4


func shake() -> void:
	offset.x = max_offset.x * _smoothed_trauma * _noise.perlin_noise2d(time, 64.0) * 2
	offset.y = max_offset.y * _smoothed_trauma * _noise.perlin_noise2d(time, 128.0) * 2

	#shift_shader_material.set_shader_parameter("shift", world_position - world_position.floor())

func _add_trauma(amount: float):
	if trauma < amount:
		trauma = amount