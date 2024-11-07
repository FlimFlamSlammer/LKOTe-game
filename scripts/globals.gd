class_name Globals

const MAX_KNOCKBACK_TIME = 0.1
const AERIAL_KNOCKBACK_MULT = 10

static func get_time_passed(timer: Timer) -> float:
	return timer.wait_time - timer.time_left