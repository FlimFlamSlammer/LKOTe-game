class_name Projectile
extends Area2D

@export var speed: float = 200.0

var speed_mult: float
var data: Dictionary
var p_direction: Vector2
var creator: CharacterBody2D
var team: Globals.Teams

func _ready() -> void:
	collision_mask = Globals.disable_team_mask(team, collision_mask)


func _physics_process(delta: float) -> void:
	position += speed * speed_mult * p_direction * delta


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		_hit_body(body)
	_finish()


func _on_lifetime_expire() -> void:
	_finish()


func _hit_body(body: CharacterBody2D) -> void:
	data.direction = sign(p_direction.x)
	data.normal = p_direction
	body.hit(data)


func _finish() -> void:
	pass