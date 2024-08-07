extends CharacterBody2D

const SPEED = 140.0
const JUMP_VELOCITY = -200.0
const COMBO_LENGTH: Array[float] = [0.35]
const RECOVERY_LENGTH: Array[float] = [0.05]
const COMBO_RESET_DELAY = 0.4
const MIN_JUMP_VELOCITY = JUMP_VELOCITY * 0.3
const DODGE_SPEED = 300.0
const DODGE_LENGTH = 0.15
const DODGE_COOLDOWN = 0.5
const RUN_SPEED_TRESHOLD = 40.0

enum State {ATTACKING, RECOVERING, DODGING, IDLE, RUNNING, JUMPING, FALLING, AIRATTACKING}
enum Action {ATTACK, DODGE, JUMP}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int = 1
var state: State = State.IDLE: set = set_state

var _time_since_attack: float = 0.0
var _time_since_recover: float = 0.0
var _time_since_dodge: float = 0.0
var _combo_progress: int = 0
var _step_distance: int = 0
var _action_buffer: Array[Action] = []

@onready var _anim_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var _dodge_effect: PackedScene = preload("res://scenes/dodge_effect.tscn")

func _physics_process(delta: float) -> void:
	# Handle state transitions
	_time_since_dodge += delta
	match state:
		State.IDLE:
			if Input.is_action_just_pressed("dodge"):
				state = State.DODGING
			elif is_on_floor():
				if Input.is_action_just_pressed("jump"):
					state = State.JUMPING
				elif Input.is_action_just_pressed("basic_attack"):
					state = State.ATTACKING
				elif absf(velocity.x) >= RUN_SPEED_TRESHOLD:
					state = State.RUNNING

			else:
				state = State.FALLING

		State.RUNNING:
			if Input.is_action_just_pressed("dodge"):
				state = State.DODGING
			elif is_on_floor():
				if Input.is_action_just_pressed("jump"):
					state = State.JUMPING
				elif Input.is_action_just_pressed("basic_attack"):
					state = State.ATTACKING
				elif absf(velocity.x) < RUN_SPEED_TRESHOLD:
					state = State.IDLE
			else:
				state = State.FALLING

		State.JUMPING:
			if Input.is_action_just_pressed("dodge"):
				state = State.DODGING
			elif Input.is_action_just_pressed("basic_attack"):
				state = State.AIRATTACKING
			elif is_on_floor():
				if abs(velocity.x) >= RUN_SPEED_TRESHOLD:
					state = State.RUNNING
				else:
					state = State.IDLE
			else:
				if velocity.y >= 0:
					state = State.FALLING

		State.FALLING:
			if Input.is_action_just_pressed("dodge"):
				state = State.DODGING
			elif Input.is_action_just_pressed("basic_attack"):
				state = State.AIRATTACKING
			elif is_on_floor():
				if absf(velocity.x) >= RUN_SPEED_TRESHOLD:
					state = State.RUNNING
				else:
					state = State.IDLE
			else:
				if velocity.y < 0:
					state = State.JUMPING

		State.ATTACKING:
			_time_since_attack += delta
			if _time_since_attack > COMBO_LENGTH[_combo_progress]:
				state = State.RECOVERING
			if is_on_floor():
				if Input.is_action_just_pressed("jump"):
					state = State.JUMPING

		State.AIRATTACKING:
			_time_since_attack += delta
			if is_on_floor():
				if Input.is_action_just_pressed("jump"):
					state = State.JUMPING
				elif absf(velocity.x) >= RUN_SPEED_TRESHOLD:
					state = State.RUNNING
				else:
					state = State.IDLE
			elif _time_since_attack > COMBO_LENGTH[_combo_progress]:
				state = State.FALLING

		State.DODGING:
			if _time_since_dodge > DODGE_LENGTH:
				if is_on_floor():
					if Input.is_action_just_pressed("jump"):
						state = State.JUMPING
					elif absf(velocity.x) >= RUN_SPEED_TRESHOLD:
						state = State.RUNNING
					else:
						state = State.IDLE
				else:
					state = State.FALLING

		State.RECOVERING:
			_time_since_recover += delta
			if Input.is_action_just_pressed("dodge"):
				state = State.DODGING
			elif _time_since_recover > RECOVERY_LENGTH[_combo_progress]:
					state = State.IDLE
			elif is_on_floor():
				if Input.is_action_just_pressed("jump"):
					state = State.JUMPING
				elif Input.is_action_just_pressed("basic_attack"):
					state = State.ATTACKING
				elif absf(velocity.x) >= RUN_SPEED_TRESHOLD:
					state = State.RUNNING
			else:
				state = State.FALLING

	# Handle state logic
	match state:
		State.IDLE:
			var input_axis: float = Input.get_axis("move_left", "move_right")
			direction = direction * (input_axis != 0 as int) + sign(input_axis)
			velocity.x = input_axis * SPEED

		State.RUNNING:
			var input_axis: float = Input.get_axis("move_left", "move_right")
			direction = direction * (input_axis != 0 as int) + sign(input_axis)
			velocity.x = input_axis * SPEED

		State.JUMPING:
			velocity.y += gravity * delta * 0.7
			# Cancel jump when button is released
			if velocity.y < MIN_JUMP_VELOCITY and not Input.is_action_pressed("jump"):
				velocity.y = MIN_JUMP_VELOCITY

			var input_axis: float = Input.get_axis("move_left", "move_right")
			direction = direction * (input_axis != 0 as int) + sign(input_axis)
			velocity.x = input_axis * SPEED

		State.FALLING:
			velocity.y += gravity * delta

			var input_axis: float = Input.get_axis("move_left", "move_right")
			direction = direction * (input_axis != 0 as int) + sign(input_axis)
			velocity.x = input_axis * SPEED

		State.DODGING:
			velocity.x = DODGE_SPEED * direction
			velocity.y = 0

		State.AIRATTACKING:
			velocity.y += gravity * delta

			var input_axis: float = Input.get_axis("move_left", "move_right")
			direction = direction * (input_axis != 0 as int) + sign(input_axis)
			velocity.x = input_axis * SPEED

	# Handle exact distance stepping
	if _step_distance > 0:
		velocity.x = _step_distance / delta * direction
		_step_distance = 0

	move_and_slide()

	# Handle state logic after move_and_slide
	match state:
		State.ATTACKING:
			velocity.x = 0


func set_state(new_state: State) -> void:
	match new_state:
		State.IDLE:
			_anim_player.play("idle")
		State.RUNNING:
			_anim_player.play("run")
		State.JUMPING:
			velocity.y = JUMP_VELOCITY
			_anim_player.play("jump")
		State.FALLING:
			_anim_player.play("fall")
		State.DODGING:
			if _time_since_dodge < DODGE_COOLDOWN:
				return
			_time_since_dodge = 0

			_anim_player.play("dodge")
			var new_dodge_effect: DodgeEffect = _dodge_effect.instantiate()
			new_dodge_effect.direction = direction
			add_child(new_dodge_effect)

		State.ATTACKING:
			_time_since_attack = 0
			_combo_progress += 1
			# Reset combo if above limit
			_combo_progress *= _combo_progress < COMBO_LENGTH.size() as int
			_anim_player.play("slash1")
		State.RECOVERING:
			_time_since_recover = 0
			_anim_player.play("idle")
		State.AIRATTACKING:
			_time_since_attack = 0
			_anim_player.play("slash1")
		_:
			push_warning("State not defined")
	state = new_state

func step(distance: int) -> void:
	_step_distance = distance
