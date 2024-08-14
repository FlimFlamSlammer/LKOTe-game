class_name Enemy
extends CharacterBody2D

const TEMP_FX: PackedScene = preload("res://scenes/temp_fx.tscn")

static var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var base_damage: float = 21.0
@export var max_health: float = 80.0

var health: float = max_health
var combo_counter: int = 0
var direction: int:
	set(new_dir):
		direction = new_dir
		scale.x = scale.y * direction

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	pass


func hit(data: Dictionary) -> void:
	direction = data.direction
	anim_player.play("hit")
	health -= data.damage
	if health <= 0:
		anim_player.play("die")


func hit_enemy() -> int:
	return -1


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
		return
	add_child(new_temp_fx)
