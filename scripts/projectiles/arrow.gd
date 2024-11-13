class_name Arrow
extends Projectile

@export var ray_cast_offset: float = 10.0

@onready var pivot: Node2D = $Pivot
@onready var ray_cast: RayCast2D = pivot.get_node("RayCast")

func _ready() -> void:
	super()
	ray_cast.collision_mask = collision_mask


func _process(delta: float) -> void:
	pivot.rotation = Vector2.ZERO.angle_to_point(p_direction)
	super(delta)

	# check collision
	var distance_moved: float = speed * delta * speed_mult
	if (resize_and_check_ray_collision(ray_cast, distance_moved, ray_cast_offset)):
		_on_body_entered(ray_cast.get_collider())


func _finish() -> void:
	queue_free()
