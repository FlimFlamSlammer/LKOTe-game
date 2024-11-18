class_name Player
extends CharacterBody2D

signal hitstop(length: float)
signal screenshake(amount: float)

signal health_changed(health: float, ratio: float)
signal max_regen_changed(max_regen: float, ratio: float)

signal stepped_to_target(step_distance: float)
signal attack_momentum_gained(distance: int, instant: bool)

enum BufferableStates {NONE, JUMPING, ATTACKING}

# Get the gravity from the project settings to be synced with RigidBody nodes.
static var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var max_health: float = 100.0
@export var regen_speed: float = 0.04
@export var endurance: float = 0.2 ## The percentage of max health used as endurance.
@export var stun_resistance: float = 1.0
@export var damage_multiplier: float = 27.0
@export var stun_time: Array[float]
@export var knockback: Array[float]
@export var combo_length: Array[float]
@export var recovery_length: Array[float]
@export var combo_damage: Array[float]
@export var impact: Array[float]
@export var attack_hitstop_multiplier: float = 2.0
@export var hit_hitstop_multiplier: float = 5.0

@export var desperation: float = 140.0
@export var jump_velocity: float = -200.0
@export var combo_reset_delay: float = 0.5
@export var min_jump_velocity: float = jump_velocity * 0.3
@export var dodge_speed: float = 2.5
@export var dodge_length: float = 0.15
@export var dodge_cooldown: float = 0.6
@export var run_speed_treshold: float = 40.0
@export var input_buffer_reset_delay: float = 0.15

var health: float = max_health
var max_regen: float = max_health ## The maximum amount of health that can be regenerated naturally.

var direction: int = 1:
	set(new_dir):
		direction = new_dir
		scale.x = scale.y * direction

var time_since_input_buffer: float = 99.9
var time_since_attack: float = 99.9
var time_since_recover: float = 99.9
var time_since_dodge: float = 99.9
var time_until_recover: float = 0.0

var input_buffer: BufferableStates = BufferableStates.NONE:
	set(value):
		input_buffer = value
		time_since_input_buffer = 0.0

var combo_counter: int = 0
var can_flip: bool

var _temp_fx: PackedScene = preload("res://scenes/temp_fx.tscn")

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateTree
@onready var targeting_ray_cast: RayCast2D = $TargetingRayCast
@onready var hurtboxes: Array[Node] = $Hurtboxes.get_children()


func _process(delta: float) -> void:
	time_since_dodge += delta
	time_since_recover += delta
	time_since_attack += delta
	time_since_input_buffer += delta
	time_until_recover -= delta

	if time_since_input_buffer > input_buffer_reset_delay:
		input_buffer = BufferableStates.NONE

	_regen_health(delta)


func hit(data: Dictionary) -> void:
	state_machine._hit(data)


func hit_enemy() -> int:
	var hit_counter: int = 0
	var candidates: Array[Node2D] = hurtboxes[combo_counter].get_overlapping_bodies()

	for candidate in candidates:
		if candidate is Enemy:
			candidate.hit({
				damage = combo_damage[combo_counter] * damage_multiplier,
				direction = direction,
				stun_time = stun_time[combo_counter],
				knockback = knockback[combo_counter],
				normal = Vector2(candidate.position.x - position.x, candidate.position.y - position.y).normalized(),
			})
			instantiate_temp_fx(TempFX.Effects.SLASH, {"variant": randi() % 2}, true, candidate.position)
			hit_counter += 1
	screenshake.emit((impact[combo_counter] + impact[combo_counter] * hit_counter * 0.3) if hit_counter > 0 else 0.015)
	if hit_counter > 0:
		hitstop.emit((impact[combo_counter] + impact[combo_counter] * hit_counter * 0.3) * attack_hitstop_multiplier)
	return hit_counter


func step_to_target() -> void:
	can_flip = false
	var target: Enemy = _get_target(targeting_ray_cast)
	var step_distance: float = 0
	if target:
		step_distance = max(absf(target.position.x - position.x) - 24, 0)
	stepped_to_target.emit(step_distance)


func gain_momentum_from_attack(distance: int, instant: bool) -> void:
	translate(Vector2.RIGHT * distance * direction)
	attack_momentum_gained.emit(distance, instant)


func instantiate_temp_fx(
	effect: TempFX.Effects,
	effect_data: Dictionary = {},
	sibling: bool = false,
	fx_position: Vector2 = Vector2.ZERO) -> TempFX:
	var new_temp_fx: TempFX = _temp_fx.instantiate()
	new_temp_fx.position = fx_position
	new_temp_fx.direction = direction
	new_temp_fx.effect = effect
	new_temp_fx.effect_data = effect_data
	if sibling:
		add_sibling(new_temp_fx)
	else:
		add_child(new_temp_fx)

	return new_temp_fx


func _get_target(ray_cast: RayCast2D) -> Enemy:
	return ray_cast.get_collider() as Enemy


func _regen_health(delta: float, mult: float = 1.0) -> void:
	if (health < max_regen):
		var regen_amount: float = mult * max_health * regen_speed * delta
		health += regen_amount
		health = min(health, max_regen)
		health_changed.emit(health, health / max_health)
