class_name Enemy
extends CharacterBody2D

@export var max_health: int = 1000

var health: int = max_health
var direction: int:
	set(new_dir):
		direction = new_dir
		scale.x = scale.y * direction

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func hit(dmg: int, attack_direction: int) -> void:
	direction = attack_direction
	anim_player.play("hit")
	health -= dmg
	if health <= 0:
		anim_player.play("die")
