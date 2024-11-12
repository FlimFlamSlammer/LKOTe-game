extends EnemySubstate

@export var charge_speed: float = 2.0
@export var max_charge_time: float = 3.0
@export var damage: float = 15.0
@export var stun_time: float = 0.4
@export var knockback: float = 12.0
@export var impact: float = 0.2

var shockwave_effect: TempFX

@onready var hurtbox: Area2D = casted_owner.get_node("MiscHurtboxes").get_node("Charge")

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	look_towards_target(true)

	casted_owner.anim_player.play("charge")
	shockwave_effect = casted_owner.instantiate_temp_fx(TempFX.Effects.SHOCKWAVE)

	casted_owner.substate_timer.start(max_charge_time)
	casted_owner.substate_timer.timeout.connect(_finish)


func _update(_delta: float) -> void:
	move_forward(charge_speed)
	apply_gravity()

	casted_owner.move_and_slide()

	if casted_owner.hit_enemy(hurtbox, {
		"damage": damage,
		"stun_time": stun_time,
		"knockback": knockback,
		"impact": impact,
	}):
		finished.emit("Recovering")
	elif casted_owner.wall_ray_cast.is_colliding():
		casted_owner.screenshake.emit(impact)
		finished.emit("Stunned")


func _exit() -> void:
	shockwave_effect.finish()
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _hit(_data: Dictionary):
	finished.emit("Stunned")


func _finish() -> void:
	finished.emit.bind("Recovering")
