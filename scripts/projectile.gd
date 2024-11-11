class_name Projectile
extends Area2D

@export var speed: float = 200.0

var speed_mult: float = 1.0
var data: Dictionary
var p_direction: Vector2 = Vector2(1, 0)
var creator: CharacterBody2D
var team: Globals.Teams

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	collision_mask = Globals.disable_team_mask(team, collision_mask)


func _physics_process(delta: float) -> void:
	translate(speed * speed_mult * p_direction * delta)
	sprite.flip_h = not sign(p_direction.x)
	

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


## Resizes the ray's vector based on [code]param distance_moved[/code] in the current frame and returns whether or not any object is colliding with the ray's vector.
## Use [code]param offset[/code] to adjust the ray's position
func resize_and_check_ray_collision(ray_cast: RayCast2D, distance_moved: float, offset: float = 0.0) -> bool:
	ray_cast.target_position.x = distance_moved
	ray_cast.position.x = offset - distance_moved
	return ray_cast.is_colliding()