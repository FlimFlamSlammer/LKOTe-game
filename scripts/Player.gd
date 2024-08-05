extends CharacterBody2D

const SPEED = 140.0
const JUMP_VELOCITY = -180.0
const COMBO_LENGTH = [0.35]
const RECOVERY_LENGTH = [0.05]
const COMBO_RESET_DELAY = 0.4
const MIN_JUMP_VELOCITY = JUMP_VELOCITY * 0.3
const DODGE_DISTANCE = 50.0
const DODGE_SPEED = 350.0
const DODGE_LENGTH = DODGE_DISTANCE / DODGE_SPEED


enum STATE {ATTACKING, RECOVERING, DODGING, IDLE, RUNNING, FLYING, AIRATTACKING}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var anim_player: AnimationPlayer

var time_since_attack = 0
var time_since_recover = 0
var time_since_dodge = 0
var combo_progress = 0
var state = STATE.IDLE
var direction = 1
var stepDistance = 0
var input_buffer = ""

func _ready():
	anim_player = get_node("AnimationPlayer")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() && state != STATE.DODGING:
		if state != STATE.AIRATTACKING:
			state = STATE.FLYING
		
		if state != STATE.AIRATTACKING:
			if velocity.y > 65:
				anim_player.play("fall")
			else:
				anim_player.play("jump")
		
		if velocity.y > 0:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 0.8
		
		# Make jump more controllable
		if velocity.y < MIN_JUMP_VELOCITY and not Input.is_action_pressed("jump"):
			velocity.y = MIN_JUMP_VELOCITY
	
	# Reset combo after a certain delay
	if combo_progress > 0 && time_since_recover > COMBO_RESET_DELAY:
		combo_progress = 0
	
	# Handle state
	if state == STATE.ATTACKING:
		time_since_attack += delta
		if time_since_attack > COMBO_LENGTH[combo_progress]:
			state = STATE.RECOVERING
			time_since_recover = 0
	elif state == STATE.RECOVERING:
		time_since_recover += delta
		if time_since_recover > RECOVERY_LENGTH[combo_progress]:
			state = STATE.IDLE
	elif state == STATE.DODGING:
		time_since_dodge += delta
		velocity.x = DODGE_SPEED * direction
		velocity.y = 0
		if time_since_dodge > DODGE_LENGTH:
			state = STATE.IDLE
	else:
		# Get movement axis to handle movement
		var input_axis = Input.get_axis("ui_left", "ui_right")
		if input_axis:
			if input_axis > 0:
				direction = 1
			elif input_axis < 0:
				direction = -1
			scale.x = scale.y * direction
			velocity.x = input_axis * SPEED
			if is_on_floor():
				state = STATE.RUNNING
				anim_player.play("run", -1, velocity.x / SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor():
				state = STATE.IDLE
				anim_player.play("idle")
	
	# Handle exact distance stepping
	if stepDistance > 0:
		velocity.x = stepDistance / delta * direction
		stepDistance = 0

	move_and_slide()

	if state == STATE.ATTACKING && is_on_floor():
		velocity.x = 0

func _unhandled_key_input(event):
	var can_override_state = true;
	can_override_state = can_override_state and not (state == STATE.ATTACKING)
	
	if can_override_state:
		if event.is_action_pressed("basic_attack"):
			time_since_attack = 0
			if state == STATE.FLYING:
				anim_player.play("slash1")
				state = STATE.AIRATTACKING
			else:
				combo_progress += 1
				if combo_progress >= COMBO_LENGTH.size():
					combo_progress = 0
				anim_player.play("slash1")
				state = STATE.ATTACKING
		if event.is_action_pressed("dodge"):
			time_since_dodge = 0
			state = STATE.DODGING
		
		if event.is_action_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY

func step(distance):
	stepDistance = distance
