class_name Globals

enum Teams {PLAYERS, NONE, ENEMIES}

const MAX_KNOCKBACK_TIME = 0.1
const AERIAL_KNOCKBACK_MULT = 10

static func get_time_passed(timer: Timer) -> float:
	return timer.wait_time - timer.time_left


static func disable_team_mask(team: Teams, mask: int) -> int:
	match team:
		Teams.PLAYERS:
			return mask & 0b100
		Teams.ENEMIES:
			return mask & 0b10
		_:
			return mask