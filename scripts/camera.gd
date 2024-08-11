class_name Camera
extends Camera2D

@export var decay: float = 0.8
@export var max_offset := Vector2(100, 75)
@export var max_roll: float = 0.1
@export var trauma_exponent: float = 1.5

static var trauma: float = 0.0
var world_position: Vector2
var target: Node2D

var _player: CharacterBody2D
var _shift_shader_material: ShaderMaterial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()

	var parent: Node = get_parent()
	_player = parent.get_node("Player")
	target = _player
	_shift_shader_material = parent.get_node("CanvasLayer/Shift").material


func _physics_process(delta: float) -> void:
	world_position += (target.position - world_position) * 0.1
	position = world_position

	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func shake() -> void:
	var amount = pow(trauma, trauma_exponent)
	rotation = max_roll * amount * randf_range(-1.0, 1.0)
	offset.x = max_offset.x * amount * randf_range(-1.0, 1.0)
	offset.y = max_offset.y * amount * randf_range(-1.0, 1.0)


	#_shift_shader_material.set_shader_parameter("shift", world_position - world_position.floor())


