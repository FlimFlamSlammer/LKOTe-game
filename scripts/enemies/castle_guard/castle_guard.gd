class_name CastleGuard
extends Enemy

const MAX_CHASE_TIME = 5.0
const MAX_DEFEND_TIME = 2.0
const SPEED = 140.0
const ATTACK_RANGE = 20.0
const DISTANCE_TO_DODGE = 30.0
const VERTICAL_ATTACK_RANGE = 20.0
const JUMP_RANGE = 60.0
const JUMP_Y_DISTANCE = -40.0
const JUMP_VELOCITY = -200.0
const MIN_JUMP_VELOCITY = JUMP_VELOCITY * 0.3

@export var target: CharacterBody2D

var time_since_attack: float = 99.9
var step_distance: float = 0.0

@onready var wall_ray_cast: RayCast2D = get_node("WallRayCast")


func _physics_process(delta: float) -> void:
	time_since_attack += delta


func step(dist: float):
	step_distance = dist
