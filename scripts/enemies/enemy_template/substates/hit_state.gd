class_name EnemyHitState
extends EnemySubstate

@export var stun_multiplier: float = 1.0
@export var knockback_multiplier: float = 1.0
@export var damage_multiplier: float = 1.0

var stun_time: float
var knockback: float
var knockback_velocity: float
var knockback_time: float
var direction: int
var aerial: bool

func _enter(_previous_state_path: NodePath, data: Dictionary = {}) -> void:
	casted_owner.anim_player.stop()
	casted_owner.anim_player.play("hit")
	casted_owner.anim_player.advance(0)

	casted_owner.health -= data.damage
	if (casted_owner.health <= 0):
		casted_owner.queue_free()

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

	casted_owner.substate_timer.start(stun_time)
	casted_owner.substate_timer.timeout.connect(_finish)


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


func _exit() -> void:
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish() -> void:
	finished.emit("Finished")


func _hit(data: Dictionary) -> void:
	finished.emit("Hit", data)
