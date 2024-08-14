extends CastleGuardState

func hit(_data: Dictionary) -> void:
	pass


func enter(_previous_state_path: String, _data: Dictionary = {}) -> void:
	casted_owner.anim_player.play("die")