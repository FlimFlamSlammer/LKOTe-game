extends PlayerState

var stun_time: float
var knockback: float
var knockback_velocity: float
var knockback_time: float
var direction: int
var aerial: bool

func _handle_input(_event: InputEvent) -> void:
	pass


func _update(delta: float) -> void:
	if aerial:
		if casted_owner.is_on_floor():
			casted_owner.velocity.x = 0
	else:
		knockback -= absf(knockback_velocity * delta)
		if knockback <= 0:
			casted_owner.velocity.x = 0

	casted_owner.velocity.y += casted_owner.gravity * delta

	casted_owner.move_and_slide()

	if casted_owner.time_until_recover <= 0.0:
		if casted_owner.is_on_floor():
			if absf(casted_owner.velocity.x) > casted_owner.run_speed_treshold:
				finished.emit(States.RUNNING)
			else:
				finished.emit(States.IDLE)
		else:
			finished.emit(States.FALLING)


func _enter(_previous_state_path: NodePath, data: Dictionary = {}) -> void:
	var health_change = -data.damage
	casted_owner.health += health_change
	casted_owner.health_changed.emit(casted_owner.health, casted_owner.health / casted_owner.max_health)

	var new_max_regen = casted_owner.health + (casted_owner.endurance * casted_owner.max_health)
	if casted_owner.health - health_change < casted_owner.max_regen:
		new_max_regen += health_change * 0.25
	if new_max_regen < casted_owner.max_regen:
		casted_owner.max_regen = new_max_regen
		casted_owner.max_regen_changed.emit(casted_owner.max_regen, casted_owner.max_regen / casted_owner.max_health)

	casted_owner.time_until_recover = data.stun_time / casted_owner.stun_resistance

	casted_owner.anim_player.play("hit")
	casted_owner.anim_player.advance(0)

	stun_time = data.stun_time
	knockback = data.knockback
	direction = data.direction

	casted_owner.direction = -direction

	aerial = not casted_owner.is_on_floor()

	if not aerial:
		knockback_time = minf(stun_time, Globals.MAX_KNOCKBACK_TIME)
		knockback_velocity = knockback / knockback_time * direction
		casted_owner.velocity.x = knockback_velocity
	else:
		casted_owner.velocity.x = knockback * direction * Globals.AERIAL_KNOCKBACK_MULT
		casted_owner.velocity.y = knockback * data.normal.y * Globals.AERIAL_KNOCKBACK_MULT

	casted_owner.screenshake.emit(data.impact)
	casted_owner.hitstop.emit(data.impact * casted_owner.hit_hitstop_multiplier)


func _exit() -> void:
	pass
