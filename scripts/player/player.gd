class_name Player
extends CharacterBody2D

const SPEED = 140.0
const JUMP_VELOCITY = -200.0
const COMBO_RESET_DELAY = 0.7
const MIN_JUMP_VELOCITY = JUMP_VELOCITY * 0.3
const DODGE_SPEED = 300.0
const DODGE_LENGTH = 0.15
const DODGE_COOLDOWN = 0.6
const RUN_SPEED_TRESHOLD = 40.0
const INPUT_BUFFER_RESET_DELAY = 0.15

enum BufferableStates {NONE, JUMPING, ATTACKING}

# Get the gravity from the project settings to be synced with RigidBody nodes.
static var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var base_damage: float = 27.0
@export var max_health: float = 100.0
@export var stun_time: float = 0.3
@export var knockback: float = 2.0

var combo_length: Array[float] = [0.35, 0.3]
var recovery_length: Array[float] = [0.2, 0.2]
var combo_damage: Array[float] = [1, 1.2]
var health: float = max_health

var direction: int = 1: set = set_direction
var time_since_input_buffer: float = 99.9
var time_since_attack: float = 99.9
var time_since_recover: float = 99.9
var time_since_dodge: float = 99.9
var input_buffer: BufferableStates = BufferableStates.NONE:
	set(value):
		input_buffer = value
		time_since_input_buffer = 0.0
var combo_counter: int = 0
var can_flip: bool
var step_distance: float = 0.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer
var _temp_fx: PackedScene = preload("res://scenes/temp_fx.tscn")

@onready var _targeting_ray_cast: RayCast2D = $TargetingRayCast
@onready var _hurtboxes: Array[Node] = $Hurtboxes.get_children()


func _physics_process(delta: float) -> void:
	time_since_dodge += delta
	time_since_recover += delta
	time_since_attack += delta
	time_since_input_buffer += delta

	if time_since_input_buffer > INPUT_BUFFER_RESET_DELAY:
		input_buffer = BufferableStates.NONE


func hit(dmg: float, _attack_direction: int) -> void:
	anim_player.play("hit")
	health -= dmg
	if health <= 0:
		anim_player.play("die")


func hit_enemy() -> int:
	var hit_counter: int = false
	var candidates: Array[Node2D] = _hurtboxes[combo_counter].get_overlapping_bodies()

	for candidate in candidates:
		if candidate is Enemy:
			candidate.hit({
				damage = base_damage,
				direction = direction,
				stun_time = stun_time,
				knockback = knockback,
			})
			instantiate_temp_fx(TempFX.Effects.SLASH, randi() % 2, true, candidate.position)
			Camera.trauma += 0.01
			hit_counter += 1
	Camera.trauma += 0.1 if hit_counter else 0.07
	return hit_counter


func set_direction(new_dir: int) -> void:
	direction = new_dir
	scale.x = scale.y * direction


func step(distance: int) -> void:
	can_flip = false
	var target: Enemy = get_target(_targeting_ray_cast)
	if target:
		if absf(target.position.x - position.x) > 18:
			step_distance = absf(target.position.x - position.x) - 26
			return
	else:
		step_distance = distance


func get_target(ray_cast: RayCast2D) -> Enemy:
	return ray_cast.get_collider() as Enemy


func instantiate_temp_fx(
		effect: TempFX.Effects,
		effect_data: int = 0,
		sibling: bool = false,
		fx_position: Vector2 = Vector2.ZERO) -> void:
	var new_temp_fx: TempFX = _temp_fx.instantiate()
	new_temp_fx.position = fx_position
	new_temp_fx.direction = direction
	new_temp_fx.effect = effect
	new_temp_fx.effect_data = effect_data
	if sibling:
		add_sibling(new_temp_fx)
		return
	add_child(new_temp_fx)
