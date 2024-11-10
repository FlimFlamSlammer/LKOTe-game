class_name EnemyDodgeState
extends EnemySubstate

@export var dodge_speed: float = 2.5
@export var dodge_length: float = 0.15

func _enter(_previous_state_path: NodePath, _data: Dictionary = {}) -> void:
	casted_owner.dodge_cooldown.start()

	move_forward(dodge_speed)
	set_dodging(true)

	casted_owner.instantiate_temp_fx(TempFX.Effects.DODGE, {
		"resource": "res://assets/3knight-dash.png"
	})
	casted_owner.anim_player.play("dodge")


func _physics_update(_delta: float) -> void:
	casted_owner.move_and_slide()
	if Globals.get_time_passed(casted_owner.dodge_cooldown) > dodge_length:
		_finished()


func _finished() -> void:
	pass


func _exit() -> void:
	set_dodging(false)
