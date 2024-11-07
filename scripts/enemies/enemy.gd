class_name Enemy
extends CharacterBody2D

signal screenshake(amount: float)

const TEMP_FX: PackedScene = preload("res://scenes/temp_fx.tscn")

static var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var stun_resistance: float = 1.0
@export var damage_multiplier: float = 1.0
@export var max_health: float = 100.0
@export var movement_speed: float = 140.0

# combo data
@export var stun_time: Array[float] = []
@export var knockback: Array[float] = []
@export var combo_damage: Array[float] = []
@export var impact: Array[float] = [] # screenshake

# ranges
@export var attack_range: float = 15.0
@export var jump_range: float = 50.0
@export var dodge_range: float = 30.0

var combo_counter: int = 0
var direction: int:
	set(new_dir):
		direction = new_dir
		scale.x = scale.y * direction

var hittable: bool = true

@onready var health: float = max_health
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var wall_ray_cast: RayCast2D = $WallRayCast
@onready var target: CharacterBody2D = get_parent().get_node("Player")
@onready var hurtboxes: Array[Node] = $Hurtboxes.get_children()

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func hit(data: Dictionary) -> void:
	var state_machine: EnemyStateMachine = get_node_or_null("StateMachine")
	if state_machine:
		state_machine._hit(data)
	else:
		direction = data.direction
		anim_player.play("hit")
		health -= data.damage
		if health <= 0:
			anim_player.play("die")

## hit_enemy data format:
## {
##  damage,
##  stun_time,
##  knockback,
##  impact(screenshake),
## }
func hit_enemy(hurtbox: Area2D, data: Dictionary) -> int:
	var hit_counter: int = 0
	var candidates: Array[Node2D] = hurtbox.get_overlapping_bodies()

	for candidate in candidates:
		if candidate is Player:
			data.direction = direction
			data.normal = Vector2(candidate.position.x - position.x, candidate.position.y - position.y).normalized()
			candidate.hit(data)
			instantiate_temp_fx(TempFX.Effects.SLASH, randi() % 2, true, candidate.position)
			hit_counter += 1
	return hit_counter


func hit_enemy_with_combo() -> int:
	var hit_counter: int = 0
	var candidates: Array[Node2D] = hurtboxes[combo_counter].get_overlapping_bodies()

	for candidate in candidates:
		if candidate is Player:
			candidate.hit({
				damage = combo_damage[combo_counter] * damage_multiplier,
				stun_time = stun_time[combo_counter],
				knockback = knockback[combo_counter],
				impact = impact[combo_counter],
			})
			instantiate_temp_fx(TempFX.Effects.SLASH, randi() % 2, true, candidate.position)
			hit_counter += 1
	return hit_counter


func instantiate_temp_fx(
		effect: TempFX.Effects,
		effect_data: int = 0,
		sibling: bool = false,
		fx_position: Vector2 = Vector2.ZERO) -> void:
	var new_temp_fx: TempFX = TEMP_FX.instantiate()
	new_temp_fx.position = fx_position
	new_temp_fx.direction = direction
	new_temp_fx.effect = effect
	new_temp_fx.effect_data = effect_data
	if sibling:
		add_sibling(new_temp_fx)
	else:
		add_child(new_temp_fx)
