extends PlayerState

var stun_time: float
var knockback: float
var knockback_velocity: float
var knockback_time: float
var direction: int
var aerial: bool

func _handle_input(_event: InputEvent) -> void:
	pass


func _physics_update(delta: float) -> void:
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
	casted_owner.time_until_recover = data.stun_time / casted_owner.stun_resistance

	casted_owner.anim_player.play("hit")
	casted_owner.anim_player.advance(0)

	stun_time = data.stun_time
	knockback = data.knockback
	casted_owner.health -= data.damage
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
