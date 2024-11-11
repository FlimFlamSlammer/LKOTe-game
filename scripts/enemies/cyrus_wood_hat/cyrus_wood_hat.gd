extends Enemy

# projectile stats
@export var arrow: PackedScene
@export var arrow_damage: float = 20.0
@export var arrow_speed: float = 1.0
@export var arrow_knockback: float = 5.0
@export var arrow_stun_time: float = 0.1
@export var arrow_impact: float = 0.1


func instantiate_arrow(
	p_direction: Vector2 = Vector2(direction, 0)
) -> void:
	_instantiate_projectile(
		arrow,
		{
			"damage": arrow_damage,
			"knockback": arrow_knockback,
			"stun_time": arrow_stun_time,
			"impact": arrow_impact
		},
		arrow_speed,
		position,
		Vector2(p_direction.x * direction, p_direction.y)
	)


func _physics_process(delta: float) -> void:
	anim_player.play("attack1")
