class_name EnemyDodgeState
extends EnemySubstate

@export var dodge_speed: float = 2.5
@export var dodge_length: float = 0.15

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.instantiate_temp_fx(TempFX.Effects.DODGE, {
		"resource": "res://assets/3knight-dash.png"
	})
	casted_owner.anim_player.play("dodge")

	casted_owner.dodge_cooldown.start()
	casted_owner.substate_timer.start(dodge_length)
	casted_owner.substate_timer.timeout.connect(_finish)

	move_forward(dodge_speed)
	set_dodging(true)


func _update(_delta: float) -> void:
	casted_owner.move_and_slide()


func _exit() -> void:
	set_dodging(false)
	casted_owner.substate_timer.timeout.disconnect(_finish)


func _finish() -> void:
	pass