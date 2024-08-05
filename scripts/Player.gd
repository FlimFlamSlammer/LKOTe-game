extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -180.0
const COMBO_LENGTH = [0.35]
const RECOVERY_LENGTH = [0.05]

enum STATE {ATTACKING, RECOVERING, DODGING, IDLE, RUNNING, FLYING}

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var anim_player: AnimationPlayer

var state_timer = 0
var combo_progress = 0
var state = STATE.IDLE
var direction = 1
var stepDistance = 0
var input_buffer = ""

func _ready():
	anim_player = get_node("AnimationPlayer")

func _physics_process(delta):
	state_timer += delta
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 0.8
		
		# Make jump more controllable
		if not Input.is_action_pressed("jump") and velocity.y < 0:
			velocity.y = 0
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_axis = Input.get_axis("ui_left", "ui_right")
	
	# handle state
	if state == STATE.ATTACKING:
		if state_timer > COMBO_LENGTH[combo_progress]:
			state = STATE.RECOVERING
			state_timer = 0
	elif state == STATE.RECOVERING:
		if state_timer > RECOVERY_LENGTH[combo_progress]:
			state = STATE.IDLE
	else:	
		if input_axis:
			if input_axis > 0:
				direction = 1
			elif input_axis < 0:
				direction = -1
			scale.x = scale.y * direction
			velocity.x = input_axis * SPEED
			state = STATE.RUNNING
			anim_player.play("run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
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
	can_override_state = can_override_state and not (state == STATE.ATTACKING and state_timer < COMBO_LENGTH[combo_progress])
	
	if can_override_state:
		if event.is_action_pressed("basic_attack"):
			if state == STATE.FLYING:
				anim_player.play()
			else:
				anim_player.play("slash1")
			if state == STATE.RECOVERING:
				combo_progress += 1
				if combo_progress >= COMBO_LENGTH.size():
					combo_progress = 0
			state = STATE.ATTACKING
			state_timer = 0
		
		if event.is_action_pressed("dodge"):
			state = STATE.DODGING
			state_timer = 0
		
		if event.is_action_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY

func step(distance):
	stepDistance = distance
