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
const MIN_ATTACKS = 2
const MAX_ATTACKS = 5
const COMBO_LENGTH: Array[float] = [0.35, 0.3]
const DODGE_SPEED = 300.0
const DODGE_LENGTH = 0.15
const DODGE_COOLDOWN = 0.6
const STUN_RESISTANCE = 1.0

var time_since_attack: float = 99.9
var time_since_dodge: float = 99.9
var time_until_recover: float = 0.0
var step_distance: float = 0.0

@onready var fatboytext: RichTextLabel = $RichTextLabel
@onready var wall_ray_cast: RayCast2D = $WallRayCast
@onready var target: CharacterBody2D = get_parent().get_node("Player")
@onready var hurtboxes: Array[Node] = $Hurtboxes.get_children()

@onready var _state_machine: CastleGuardStateMachine = $StateTree

func _physics_process(delta: float) -> void:
	time_since_attack += delta
	time_since_dodge += delta
	time_until_recover -= delta


func step(dist: float):
	step_distance = dist

func hit_enemy() -> int:
	var hit_counter: int = 0
	var candidates: Array[Node2D] = hurtboxes[combo_counter].get_overlapping_bodies()

	for candidate in candidates:
		if candidate is Player:
			candidate.hit(base_damage, direction)
			instantiate_temp_fx(TempFX.Effects.SLASH, randi() % 2, true, candidate.position)
			Camera.trauma += 0.01
			hit_counter += 1
	Camera.trauma += 0.1 if hit_counter else 0.07
	return hit_counter

func hit(data: Dictionary) -> void:
	_state_machine.hit(data)
