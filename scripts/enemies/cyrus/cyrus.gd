class_name Cyrus
extends Enemy

# projectile stats
@export var arrow: PackedScene
@export var arrow_damage: float = 20.0
@export var arrow_speed: float = 1.0
@export var arrow_knockback: float = 5.0
@export var arrow_stun_time: float = 0.1
@export var arrow_impact: float = 0.1

@onready var dodge_cooldown: Timer = $DodgeCooldown
@onready var substate_timer: Timer = $SubstateTimer
@onready var state_timer: Timer = $StateTimer


func instantiate_arrow(
	offset: Vector2 = Vector2.ZERO,
	p_direction: Vector2 = Vector2(1, 0)
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
		position + Vector2(offset.x * direction, offset.y),
		Vector2(p_direction.x * direction, p_direction.y)
	)
