class_name EnemyCore
extends Node

const ENEMY_COLLISION_LAYER = 0b10

@onready var casted_owner: Enemy = owner

# Conditionals

func can_jump() -> bool: # target in air check
	var y_distance: float = get_target_relative_position().y
	return _target_in_jump_range() and y_distance < 0


func target_in_attack_range() -> bool:
	var x_distance: float = get_target_relative_position().x
	if absf(x_distance) < casted_owner.attack_range:
		return true
	return false;


func target_in_air_attack_range() -> bool: # using y prediction
	var y_distance: float = get_target_relative_position().y

	return (y_distance > -casted_owner.vertical_attack_range
			and y_distance < casted_owner.vertical_attack_range
			and target_in_attack_range())


func is_hittable() -> bool:
	return casted_owner.collision_layer & ENEMY_COLLISION_LAYER == ENEMY_COLLISION_LAYER


func can_dodge() -> bool:
	return casted_owner.dodge_cooldown.is_stopped()


func target_in_vertical_attack_range() -> bool:
	var y_distance: float = get_target_relative_position().y
	if absf(y_distance) < casted_owner.vertical_attack_range:
		return true
	return false


func _target_in_jump_range() -> bool: # check if target is close enough to jump
	var distance: Vector2 = get_target_relative_position()
	if absf(distance.x) < casted_owner.jump_range:
		if distance.y < casted_owner.jump_y_treshold:
			return true
	return false


# Useful functions

func get_target_relative_position() -> Vector2: # distance from target, used for attack checking
	return Vector2(casted_owner.target.position.x - casted_owner.position.x, _get_target_predicted_relative_y())


func look_towards_target(look_towards: bool) -> void: #
	if (get_target_relative_position().x > 0) == look_towards:
		casted_owner.direction = 1
	else:
		casted_owner.direction = -1


func apply_gravity() -> void:
	casted_owner.velocity.y += casted_owner.gravity


func move_forward(speed_mult: float = 1) -> void:
	casted_owner.velocity.x = speed_mult * casted_owner.movement_speed * casted_owner.direction


func set_hittable(hittable: bool) -> void:
	casted_owner.hittable = hittable
	_set_hittable_layer(hittable)


func set_dodging(dodging: bool) -> void:
	_set_hittable_layer(not dodging and casted_owner.hittable)


func _set_hittable_layer(hittable: bool) -> void: # only changes layer, no vars changed
	if is_hittable() != hittable: # check if 2nd layer is correct (active/inactive)
		casted_owner.collision_layer = casted_owner.collision_layer ^ ENEMY_COLLISION_LAYER # toggle 2nd layer


func _get_target_predicted_relative_y() -> float: # used for aerial attacks
	var predicted_y = (
			casted_owner.target.position.y
			+ casted_owner.target.velocity.y * 0.1
			- casted_owner.velocity.y * 0.1
		) # predict y based on both y velocities
	return predicted_y - casted_owner.position.y
